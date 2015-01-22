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
class AssetsController < ApplicationController

  # Disable cookie protection for everything except couple function
  protect_from_forgery :only => [:create, :update, :destroy]
                        
  require 'networking'

  # GET /assets
  # GET /assets.xml
  def index
    @assets = Asset.paginate :page => params[:page], :per_page => 30, :order => 'name'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assets }
    end
  end

  def getallassets
    @assets = Asset.all

    render :json => @assets
  end

  # GET /assets/1
  # GET /assets/1.xml
  def show
    @asset = Asset.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/new
  # GET /assets/new.xml
  def new
    @asset = Asset.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/1/edit
  def edit
    @asset = Asset.find(params[:id])
  end

  # POST /assets
  # POST /assets.xml
  def create
    @asset = Asset.new(params[:asset])

    respond_to do |format|
      if @asset.save
        flash[:notice] = 'Asset was successfully created.'
        #format.html { redirect_to(@asset) }
        format.html { redirect_to(assets_url) }
        format.xml  { render :xml => @asset, :status => :created, :location => @asset }

      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assets/1
  # PUT /assets/1.xml
  def update
    @asset = Asset.find(params[:id])
    
    respond_to do |format|
      if @asset.update_attributes(params[:asset])
        flash[:notice] = 'Asset was successfully updated.'
        format.html { redirect_to(@asset) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.xml
  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |format|
      format.html { redirect_to(assets_url) }
      format.xml  { head :ok }
    end
  end
  
  # Create dns cname
  def create_dns_cname

    @asset = Asset.find(params[:id])
    
    dns_cname = DnsCnameDetail.new(:name => params[:dns_cname][:name])
    dns_cname.asset = @asset
    
    begin
      dns_cname.save! 
    rescue Exception => exc
      flash[:dns_cname] = "CName create failed with following reason: #{exc.message}"
    end
    
    render(:partial => "assets/dns_cname",:object => @asset)
    
  end
  
  def destroy_dns_cname
    dns_cname = DnsCnameDetail.find(params[:id])
    @asset = dns_cname.asset
    
    # remove dns
    dns_cname.destroy
    
    render(:partial => "assets/dns_cname",:object => @asset)
  end
  
  def get_my_ip
    asset = Asset.find_by_name(params['hostname'])

    if ! asset.nil?
      interfaces = Hash.new()
      interfaces["eth"] = Array.new()
      interfaces["vip"] = Array.new()
      intCnt = 1
      # Pickup interface
      asset.non_drac_interfaces.each { |i|
        interface = Hash.new()
        cidr = NetAddr::CIDR.create(i.vlan_detail.subnet)
        interface["ip"] = i.ip_to_string
        # First IP is the default gateway
        interface["gateway"] = Networking.i_to_ip(NetAddr.ip_to_i(cidr.first) + 1)
        interface["netmask"] = Networking.i_to_ip(NetAddr.netmask_to_i(cidr.netmask))
        interface["network"] = cidr.first
        interface["broadcast"] = cidr.last
        if i == asset.primary_interface
          interface["intCnt"] = "0"
        else
          interface["intCnt"] = "#{intCnt}"
          intCnt += 1
        end
        interfaces["eth"].push(interface)
      }
      intCnt = 1
      # Find VIP asset serves and create lo address
      asset.vip_before_me.each { |v|
        interface = Hash.new()
        interface["int"] = "lo:#{intCnt}"
        interface["ip"] = v.vip_asset.resource.interface.ip_to_string
        interface["netmask"] = "255.255.255.255"
        interface["intCnt"] = "#{intCnt}"
        intCnt += 1
        interfaces["vip"].push(interface)
      }

      render :json => interfaces.to_json
    else
      render :json => '{"error": 1}'
    end
  end

  # Returns a bash executable to create interface files
  def get_my_ip2
    asset = Asset.find_by_name(params['hostname'])

    intCnt = 1
    @o = "#!/bin/bash\n"
    @o += "OUTDIR=/tmp\n"
    @o += "if [ -z $ETHNAME ]; then echo 'Set ETHNAME to eth or em first'; exit 1; fi\n"
    if ! asset.nil?
      asset.non_drac_interfaces.each { |i|
        interface = Hash.new()
        cidr = NetAddr::CIDR.create(i.vlan_detail.subnet)
        if i == asset.primary_interface
          @o += "eth=\"${ETHNAME}\"\n"
        else
          @o += "eth=\"${ETHNAME}:#{intCnt}\"\n"
          intCnt += 1
        end
        @o += "echo \"#Generated by AST\n" 
        @o += "DEVICE=${eth}\n"
        @o += "BOOTPROTO=none\n"
        @o += "IPV6INIT=yes\n"
        @o += "ONBOOT=yes\n"
        @o += "TYPE=Ethernet\n"
        @o += "IPADDR=" + i.ip_to_string + "\n"
        @o += "NETMASK=" + Networking.i_to_ip(NetAddr.netmask_to_i(cidr.netmask)) + "\n"
        if i == asset.primary_interface
          # First IP is the default gateway
          @o += "# First IP.  Ensure this is correct before apply\n"
          @o += "GATEWAY=" + Networking.i_to_ip(NetAddr.ip_to_i(cidr.first) + 1) + "\n"
        end
        @o += "\" > \"$OUTDIR/ifcfg-${eth}\"\n"
        @o += "\n"
        @o += "cat \"$OUTDIR/ifcfg-${eth}\"\n"
      }

      intCnt = 1
      # Find VIP asset serves and create lo address
      asset.vip_before_me.each { |v|
        @o += "echo \"#Generated by AST\n" 
        @o += "DEVICE=lo:#{intCnt}\n"
        @o += "ONBOOT=yes\n"
        @o += "IPADDR=" + v.vip_asset.resource.interface.ip_to_string + "\n"
        @o += "NETMASK=255.255.255.255\"\n"
        @o += " > \"$OUTDIR/ifcfg-lo:#{intCnt}\"\n"
        @o += "\n"
        @o += "cat \"$OUTDIR/ifcfg-lo:#{intCnt}\"\n"
        intCnt += 1
      }
    else
      o += "echo 'Asset not found'"
      o += "exit 1"
    end
    respond_to do |format|
      format.html { render :partial => 'get_my_ip2', :layout => false, :object => @o }
    end
  end

  def getkscassets
    server_type = 'ksc%'
    server_assets = Asset.find(:all, :conditions => ['name LIKE ?', server_type])
    output = Array.new
    server_assets.each { |a|
      s = Hash.new
      s['asset_id'] = a.id
      s['name'] = a.name
      s['ip_address'] = a.primary_interface.ip_to_string
      s['colo_name'] = a.colo.name
      s['resource_type'] = a.resource_type
      s['management_zone'] = a.colo.name[0..2]
      s['manufacturer'] = ''
      s['model'] = ''
      s['created_timestamp'] = a.created_at

      output << s
    }
    render :json => output
  end

  def getallservers
    assets = Asset.find(:all, :conditions => ['resource_type = "Server"'])
    render :json => assets.collect{|a| a.name}
  end

  def getallnetworks
    assets = Asset.find(:all, :conditions => ['resource_type = "Network"'])
    output = Array.new
    assets.each { |a|
      s = Hash.new
      s['hostname'] = a.name
      s['colo'] = a.colo.name
      networks = Array.new
      a.interfaces.each{|i|
        interface = Hash.new
        interface['vlan'] = i.vlan_detail.vlan.name
        interface['ip'] = i.ip_to_string
        networks << interface
      }
      s['network'] = networks
      output << s  
    }
    render :json => output
  end

end

