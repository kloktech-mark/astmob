# Copyright 2011 Google Inc. All Rights Reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class ServersController < ApplicationController
  require 'networking'

  # GET /servers
  # GET /servers.xml
  def index
    @servers = Server.paginate :page => params[:page], :per_page => 30, :order => 'id desc'

    #@servers = Server.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @servers }
    end
  end

  # GET /servers/1
  # GET /servers/1.xml
  def show
    @server = Server.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @server }
    end
  end

  # GET /servers/new
  # GET /servers/new.xml
  def new
    @server = Server.new
    @server.asset = Asset.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @server }
    end
  end

  # GET /servers/1/edit
  def edit
    @server = Server.find(params[:id])
    #raise @server.asset.revisions.inspect
  end

  # POST /servers
  # POST /servers.xml
  def create
    @server = Server.new(params[:server])
    @asset = Asset.new(params[:asset])
    @server.asset = @asset
    
    respond_to do |format|
      if @server.save
        # If server is saved correctly, we'll assign drac ip to the box
        Networking.get_drac_ip(@server.asset)
        flash[:notice] = 'Server was successfully created.'
        format.html { render :action => "edit" }
        #format.html { redirect_to(@server) }
        format.xml  { render :xml => @server, :status => :created, :location => @server }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @server.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /servers/1
  # PUT /servers/1.xml
  def update
    @server = Server.find(params[:id])
    
    old_colo = @server.asset.colo
    
    @server.attributes = params[:server]
    @server.asset.attributes = params[:asset]
    
    respond_to do |format|
      if @server.save && @server.asset.save
        if old_colo != Server.find(params[:id]).asset.colo
          # Remove all interfaces that servers owns
          Interface.destroy(@server.asset.interfaces)
          # Clean out the array so subsequent display of the asset looks right.
          @server.asset.interfaces = {}
          # Create a drac ip for the asset
          Networking.get_drac_ip(@server.asset)
        end
        flash[:notice] = 'Server was successfully updated.'
        format.html { render :action => "edit" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @server.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /servers/1
  # DELETE /servers/1.xml
  def destroy
    @server = Server.find(params[:id])
    @server.destroy

    respond_to do |format|
      format.html { redirect_to(servers_url) }
      format.xml  { head :ok }
    end
  end
  
  # Provisioning server
  def provision
    @server = Server.find(params[:id])

    respond_to do |format|
        format.html { }
        format.xml  { render :xml => @server, :status => :created, :location => @server }
    end
  end
  
  def update_from_ocs
    cur_time = Time.now
    @o = Array.new
    @server = Server.find(params[:id])
 
    #build the correct name for OCS then get the OCS object
    @ocs_server = OcsHardware.find(:first, :conditions => ["deviceid = ?", @server.name])
    if ! @ocs_server.blank?
      ## Populate the AST variables
      @ast_cpu = CpuDetail.find(:first, :conditions => ["asset_id = ?", @server.asset.id ])
      @ast_disk = DiskDetail.find(:all, :conditions => ["asset_id = ?", @server.asset.id ])
      @ast_memory = MemoryDetail.find(:all, :conditions => ["asset_id = ?", @server.asset.id ])
      @ast_nic = Interface.find(:all, :conditions => ["asset_id = ?", @server.asset.id ])
    
      ## Populate the OCS variables 
      @ocs_storage_devices = OcsStorage.find(:all, :conditions => ["hardware_id = ?", @ocs_server.id])
      @ocs_memory_modules = OcsMemory.find(:all, :conditions => ["hardware_id = ?", @ocs_server.id])
      @ocs_nics = OcsInterface.find(:all, :conditions => ["hardware_id =?", @ocs_server.id])

      #check if AST fields exist, then update or create AST fields with OCS data
      ## Update CPU info
      if @ast_cpu.blank?
        b = CpuDetail.new
        b.asset_id = @server.asset.id
        b.cpu_model_id = 0
        b.save
        @ast_cpu = CpuDetail.find(:first, :conditions => ["asset_id = ?", @server.asset.id ])
      end
      @o = @ast_cpu.update_cpu_model_from_ocs(@ocs_server, @o)
      @o = @ast_cpu.update_cpu_cores_from_ocs(@ocs_server, @o)
        
      ##Update Service Tag
      @o = @server.update_service_tag(@ocs_server, @o)
      
      ##Update Bios Version
      @o = @server.update_server_bios(@ocs_server, @o)
      
      ##Update Server Model/Manufacturer
      @o = @server.update_server_model(@ocs_server, @o)
      
      ##Update Storage
      myDisks = Array.new
      @ocs_storage_devices.each do |i|
        if i.TYPE == "disk"
          myDisks << i
        end
      end
      myDisks.each do |i|
        @o = i.update_storage_from_ocs(@ast_disk, @o, @server)
      end    
      # Delete from AST any extra/remaining entries
      if ! @ast_disk.blank?
        @ast_disk.each do |i|
          i.destroy
        end
        @o << "Removed extraneous disk entries. "
      end
      
      ##Update Memory
      @ocs_memory_modules.each do |i|
        @o = i.update_memory_from_ocs(@ast_memory, @o, @server)
      end
      # Delete from AST any extra/remaining entries
      if ! @ast_memory.blank?
        @ast_memory.each do |i|
          i.destroy
        end
        @o << "Removed extraneous memory entries. "
      end
      ## Update MAC only if IP's match. Otherwise, send out an alert.
      if ! @ast_nic.blank?
        myNic = Array.new
        @ocs_nics.each do |i|
          if ! i.IPADDRESS.blank? and ! i.MACADDR.blank?
            myNic << i
          end
        end 
        myNic.each do |i|
          @o = i.update_mac_from_ocs(@ast_nic, @o)
        end
      end
    else
      @o = "not_in_ocs"
    end
    if @o.blank?
      @o = cur_time.to_s + ": No update required. Doing nothing."
      flash[:notice] = @o
    elsif @o == "not_in_ocs"
      @o = cur_time.to_s + ": Server not found in OCS. Doing nothing."
      @server.update_notes(cur_time.to_s, @o.to_s)
      flash[:notice] = @o     
    else
      @server.update_notes(cur_time.to_s, @o.to_s)
      flash[:status] = @o
    end
    render(:update) { |page| page.call 'location.reload' }
  end

  # Assign an ip to asset
  def assigning
    #require 'networking'
    
    @server = Server.find(params[:id])
    
    @vlan_detail = VlanDetail.find(params[:vlan_detail][:vlan_detail_id])

    # Go through asset's interfaces, if it's not drac and not the same as the one user just select,
    # Delete it.
    for interface in @server.asset.interfaces
      if interface.vlan_detail.vlan.drac != true && interface.vlan_detail != @vlan_detail
        interface.destroy
      end
    end

    Networking.get_an_ip(@server.asset,params[:vlan_detail][:vlan_detail_id])
    flash[:notice] = 'Server successfully provisioned to new vlan.'

    respond_to do |format|
        format.html { redirect_to(edit_server_path(@server)) }
        format.xml  { render :xml => @server, :status => :created, :location => @server }
    end
  end

end
