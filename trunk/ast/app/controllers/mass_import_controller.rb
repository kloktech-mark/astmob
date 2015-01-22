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
class MassImportController < ApplicationController
  
  require "networking"
  
  # Build the index page for various add
  def index
    @vlan_details = []
    all_v = VlanDetail.find(:all, :include => [:colo,:vlan])
    all_v.sort{|a,b| a.colo.name <=> b.colo.name}.each {|v|
      if ! v.vlan.drac
        @vlan_details << [v.colo.name + ' - ' + v.vlan.name + ' - ' + v.vlan.vlan_number.to_s, v.id]
      end
    }
    @colos = []
    Colo.all.sort{|a,b| a.name.downcase <=> b.name.downcase}.each{|c| 
      @colos << [c.name, c.id]
    }
       
     #raise @vlan_details.inspect
  end

  def mass_server_mac
    @o = ''
    
    # Parse the textarea with each newline
    data = params[:mass_import][:data].split("\r\n")
    
    # Find the 
    vlan_detail = VlanDetail.find(params[:mass_import][:vlan_detail_id])
    
    # Parse each row in the text area
    for i in data
      j = i.split("|")
      name = j[0].lstrip.rstrip 
      mac_raw = j[1].lstrip.rstrip
      if mac_raw.length != 12
        @o += "#{name} has incorrect mac #{mac_raw}"
        next
      end

      mac = mac_raw.downcase.scan(/.{2}/).join(":")

      @server = Server.new()
      @asset = Asset.new(:name => name)
      @asset.colo = vlan_detail.colo
      @server.asset = @asset
      
      if @server.save
        # If server is saved correctly, we'll assign drac ip to the box
        Networking.get_drac_ip(@server.asset)
        
        # And we will assign a vlan error as well.
        Networking.get_an_ip(@server.asset,vlan_detail)

        @asset.primary_interface.update_attribute(:mac, mac)
        
        # And we will also assign a ip to destination 
        @o += "Server was successfully created.\n"
      else
        @o += "#{name} FAILED with \"#{@server.asset.errors.full_messages}\" \n"
      end
    end
    render :template => "mass_import/mass_server.html.erb"
  end

  def mass_free
    @o = ''
    
    # Parse the textarea with each newline
    data = params[:mass_import][:data].split("\r\n")
    
    # Find colo 
    colo = Colo.find(params[:mass_import][:colo_id])
    
    @o += "colo: " + colo.name + "\n"
    # Parse each row in the text area
    for i in data
      @server = Server.new()
      @asset = Asset.new(:name => i)
      @asset.colo = colo
      @server.asset = @asset
      
      if @server.save
        # If server is saved correctly, we'll assign drac ip to the box
        Networking.get_drac_ip(@server.asset)
        
        # And we will also assign a ip to destination 
        @o += "#{i} was successfully created.\n"
      else
        @o += "#{i} FAILED with \"#{@server.asset.errors.full_messages}\" \n"
      end
    end
    render :template => "mass_import/mass_server.html.erb"
  end

  def mass_server
    @o = ''
    
    # Parse the textarea with each newline
    data = params[:mass_import][:data].split("\r\n")
    
    # Find the 
    vlan_detail = VlanDetail.find(params[:mass_import][:vlan_detail_id])
    
    # Parse each row in the text area
    for i in data
      @server = Server.new()
      @asset = Asset.new(:name => i)
      @asset.colo = vlan_detail.colo
      @server.asset = @asset
      
      if @server.save
        # If server is saved correctly, we'll assign drac ip to the box
        Networking.get_drac_ip(@server.asset)
        
        # And we will assign a vlan error as well.
        Networking.get_an_ip(@server.asset,vlan_detail)
        
        # And we will also assign a ip to destination 
        @o += "#{i} was successfully created.\n"
      else
        @o += "#{i} FAILED with \"#{@server.asset.errors.full_messages}\" \n"
      end
    end
  end
  
  # Import drac IP
  def drac_ip
    @o = ''
    # Take text input from mass_import params split by new line.
   
    # Parse the textarea with each newline
    data = params[:mass_import][:data].split("\r\n")
    
    # Parse each row in the text area
    for i in data
      
      j = i.split(",")
      # Strip out the space before and after hostname & IP
      host = j[0].lstrip.rstrip
      ip = j[1].lstrip.rstrip
      
      asset = server = Asset.find(:first, :conditions => ["name = ?", host])
  
      # If asset is not found in ast, skip it with error message
      if asset.nil?
        @o += "#{host} NOT FOUND in ast.\n"
        next
      end
      
      vlan_detail = Networking.get_vlan_for_ip(ip)

      # Check if vlan owning the ip is a drac
      if ! vlan_detail.nil? && vlan_detail.vlan.drac
        i = Interface.new()
        i.asset = asset
        i.ip = ip
        i.vlan_detail = vlan_detail
        if i.save
          @o += "#{j[0]} with ip #{j[1]} saved successfully.\n"
        else
          @o += "#{j[0]} with ip #{j[1]} FAILED with \"#{i.errors.full_messages}\" \n"
        end
      else
        @o += "#{j[0]} with ip #{j[1]} does NOT belong to drac vlan.\n"
      end
      
    end
    
    @o += "\nServer WITHOUT Drac\n"
    servers = Server.find(:all)
    
    for server in servers
      if server.colo.name == 'sc9' and ! server.got_drac
        @o += "#{server.name} did not get a drac IP\n"
      end
    end
  end

  def mass_rack
    @o = ''
    # Take text input from mass_import params split by new line.
   
    # Parse the textarea with each newline
    data = params[:mass_import][:data].split("\r\n")
       
    # Parse each row in the text area
    for i in data

      j = i.split("|")
      
      # Strip out the space before and after hostname & IP
      name = j[0].lstrip.rstrip 
      # even number = hostname, odd number = service name
      row = j[1].lstrip.rstrip
      rack = j[2].lstrip.rstrip
      pos = j[3].lstrip.rstrip
      
      if asset = Asset.find_by_name(name)
        
        #raise asset.inspect
        asset.row = row
        asset.rack = rack
        asset.pos = pos

        # save the asset
        if asset.save 
          @o += "Asset #{asset.name} updated with row #{asset.row} rack #{asset.rack} pos #{asset.pos} <br/>"
        end
      else
        @o += "!! #{name} does NOT exist !!<br/>"  
      end
    end
    render :template => "mass_import/nagios_service.html.erb"
  end  

  # Mass video asset import
  def mass_video
    @o = ''
    # Take text input from mass_import params split by new line.
   
    # Parse the textarea with each newline
    data = params[:mass_import][:data].split("\r\n")
    
    # Parse each row in the text area
    for i in data
      
      j = i.split(",")
      # Strip out the space before and after hostname & IP
      host = j[0].lstrip.rstrip.downcase
      ip = j[1].lstrip.rstrip

      # Pick up the vlan_detail and colo
      vlan_detail = Networking.get_vlan_for_ip(ip)
      if vlan_detail.nil?
        @o += "#{ip} isn't in any vlan, skipping #{host}\n" 
        next
      end

      asset = Asset.find(:first, :conditions => ["name = ?", host])

      if asset.nil?
        video = Video.new()
        asset = Asset.new(:name => host)
        asset.colo = vlan_detail.colo
        video.asset = asset
        video.save
        @o += "Created #{host}.\n"
      else
        video = asset.resource
      end
      
      # Pick up video model information if presented.
      if (!j[2].nil? and !j[3].nil?) 
        manufacture = j[2].lstrip.rstrip
        model = j[3].lstrip.rstrip
        video_model = VideoModel.find_or_create_by_manufacture_and_model(manufacture,model)
        video.video_model = video_model
        video.save
      end
  
      # Check if IP is already used, if so, skip.
      if Interface.find(:first, :conditions => ["ip = ?", Networking.ip_to_i(ip)]).nil?
        i = Interface.new()
        i.asset = video.asset
        i.ip = ip
        i.vlan_detail = vlan_detail
        i.save
      else
        @o += "#{ip} already taken, skipping.\n"
        next
      end

      @o += "#{host} with ip #{ip} imported successfully.\n"
    end

    render :template => "mass_import/mass_server.html.erb"
  end

  def mass_add_generic
    @o = ''
   
    # Parse the textarea with each newline
    data = params[:mass_import][:data].split("\r\n")
    asset_type = params[:mass_import][:asset_type]
    
    # Parse each row in the text area
    for i in data
      
      j = i.split(",")
      # Strip out the space before and after hostname & IP
      host = j[0].lstrip.rstrip.downcase
      ip = j[1].lstrip.rstrip

      # Pick up the vlan_detail and colo
      vlan_detail = Networking.get_vlan_for_ip(ip)
      if vlan_detail.nil?
        @o += "#{ip} isn't in any vlan, skipping #{host}\n" 
        next
      end

      asset = Asset.find(:first, :conditions => ["name = ?", host])

      if asset.nil?
        this_asset = Object::const_get(asset_type).new()
        asset = Asset.new(:name => host)
        asset.colo = vlan_detail.colo
        this_asset.asset = asset
        this_asset.save
        @o += "Creating #{host}.\n"
      else
        this_asset = asset.resource
        # If existing asset isn't the right asset type, delete and create
        if ! this_asset.is_a? Object::const_get(asset_type)
          @o += "<font color='red'>Error</font>: #{host}(#{ip}) should be #{asset_type} but is in AST as #{this_asset.class}, deleting existing asset and recreate.\n"
          asset.destroy
          this_asset = Object::const_get(asset_type).new()
          asset = Asset.new(:name => host)
          asset.colo = vlan_detail.colo
          this_asset.asset = asset
          this_asset.save
          @o += "Re-created #{host} as #{asset_type}.\n"
        end
      end
      
      if ! asset.id.nil?
        i = Interface.find(:first, :conditions => ["ip = ?", Networking.ip_to_i(ip)])
  
        # Check if IP is already used, if so, skip.
        if i.nil?
          new_i = Interface.new()
          new_i.asset = this_asset.asset
          new_i.ip = ip
          new_i.vlan_detail = vlan_detail
          new_i.save
        else
          if i.asset == this_asset.asset
            @o += "#{host} already has #{ip}.\n"
          else
            @o += "<font color='red'>Err</font>: #{ip} is taken by #{i.asset.name}, skipping.\n"
          end
        end
        
        # Pick up asset type model information if presented.
        if (!j[2].nil? and !j[3].nil?) 
          manufacture = j[2].lstrip.rstrip
          model = j[3].lstrip.rstrip
  
          case asset_type
          when "Network"
            asset_model = NetworkModel.find_or_create_by_manufacture_and_model(manufacture,model)
            @o += "added to model '#{asset_model.manufacture} - #{asset_model.model}'"
            this_asset.network_model = asset_model
            this_asset.save
          when "Pdu"
            asset_model = PduModel.find_or_create_by_manufacture_and_model(manufacture,model)
            this_asset.pdu_model = asset_model
            this_asset.save
          end
        end
        @o += "#{host} with ip #{ip} imported successfully.\n"
      else
        @o += "<font color='red'>Err</font>: Unable to create asset with name '#{host}', check if it's valid.\n"
      end
    end
    render :template => "mass_import/mass_server.html.erb"
  end

  def nmap_result
    @o = ''
   
    # Parse the textarea with each newline
    data = params[:mass_import][:data].split("\r\n")
    asset_type = params[:mass_import][:asset_type]
    
    ip_list = Hash.new
    ip_list['null'] = Hash.new
    ip_list['null']['null'] = Array.new
    # Parse each row in the text area
    for i in data
      j = i.split
      # Strip out the space before and after hostname & IP
      ip = j[1].lstrip.rstrip.downcase
      if ( ip.split(".").length == 4 )
        #ip_list << ip
        vlan_detail = Networking.get_vlan_for_ip(ip)
        if vlan_detail.nil?
          ip_list['null']['null'] << ip
        else
          name = vlan_detail.colo.name + ':' + vlan_detail.vlan.name
          if ip_list[vlan_detail.colo.name].nil?
            ip_list[vlan_detail.colo.name] = Hash.new
          end
          if ip_list[vlan_detail.colo.name][vlan_detail.vlan.name].nil?
            ip_list[vlan_detail.colo.name][vlan_detail.vlan.name] = Array.new
          end
          ip_list[vlan_detail.colo.name][vlan_detail.vlan.name] << ip
        end
      end
    end
    ip_list.each do |colo, vlans|
      @o += "<b>#{colo}</b>\n"
      vlans.each do |name, ips|
        @o += "  #{name} - #{ips.length} total IPs\n";
        if name == 'null'
          ips.each do |ip|
            @o += "#{ip} \n";
          end
        end
      end
      @o += "\n";
    end
    #@o += ip_list.inspect
    render :template => "mass_import/mass_server.html.erb"
  end

  def mass_add_interface
    @o = ''
   
    # Parse the textarea with each newline
    data = params[:mass_import][:data].split("\r\n")
    asset_type = params[:mass_import][:asset_type]
    
    # Parse each row in the text area
    for i in data
      
      j = i.split(",")
      # Strip out the space before and after hostname & IP
      ip = j[0].lstrip.rstrip
      interface_name = j[1].lstrip.rstrip.downcase
      host = j[2].lstrip.rstrip.downcase
      primary_bool = j[3].lstrip.rstrip

      # Pick up the vlan_detail and colo
      vlan_detail = Networking.get_vlan_for_ip(ip)
      if vlan_detail.nil?
        @o += "#{ip} isn't in any vlan, skipping #{host}\n" 
        next
      end

      asset = Asset.find(:first, :conditions => ["name = ?", host])

      if asset.nil?
        @o += "Creating #{host}.\n"
        this_asset = Object::const_get(asset_type).new()
        asset = Asset.new(:name => host)
        asset.colo = vlan_detail.colo
        this_asset.asset = asset
        this_asset.save
      else
        this_asset = asset.resource
        # If existing asset isn't the right asset type, delete and create
        if ! this_asset.is_a? Object::const_get(asset_type)
          @o += "<font color='red'>Error</font>: #{host}(#{ip}) should be #{asset_type} but is in AST as #{this_asset.class}, deleting existing asset and recreate.\n"
          asset.destroy
          this_asset = Object::const_get(asset_type).new()
          asset = Asset.new(:name => host)
          asset.colo = vlan_detail.colo
          this_asset.asset = asset
          this_asset.save
          @o += "Re-created #{host} as #{asset_type}.\n"
        end
      end
      
      if ! asset.id.nil?
        i = Interface.find(:first, :conditions => ["ip = ?", Networking.ip_to_i(ip)])
  
        # Check if IP is already used, if so, skip.
        if i.nil?
          new_i = Interface.new()
          new_i.asset = this_asset.asset
          new_i.ip = ip
          new_i.vlan_detail = vlan_detail
          new_i.name = interface_name
          if primary_bool == "1"
            new_i.real_ip = true
          end
          new_i.save
        else
          if i.asset == this_asset.asset
            @o += "#{host} already has #{ip}.\n"
          else
            @o += "<font color='red'>Err</font>: #{ip} is taken by #{i.asset.name}, skipping.\n"
          end
        end
        @o += "#{host} with ip #{ip} imported successfully.\n"
      else
        @o += "<font color='red'>Err</font>: Unable to create asset with name '#{host}', check if it's valid.\n"
      end
    end
    render :template => "mass_import/mass_server.html.erb"
  end

  def mass_delete
    @o = ''
    
    # Parse the textarea with each newline
    data = params[:mass_import][:data].split("\r\n")
    
    # Parse each row in the text area
    for i in data
      name = i.lstrip.rstrip 
      begin
        asset = Asset.find_by_name(name)
        resource = asset.resource
        resource.destroy
        @o += "#{name} was successfully deleted.\n"
      rescue
        @o += "<font color='red'>Err</font>:#{name} failed deletion.\n"
      end
      
    end
    render :template => "mass_import/mass_server.html.erb"
  end

  def mass_delete_interface
    @o = ''
    
    # Parse the textarea with each newline
    data = params[:mass_import][:data].split("\r\n")
    
    # Parse each row in the text area
    for i in data
      ip = i.lstrip.rstrip 
      begin
        interface = Interface.find_by_ip(Interface.ip_to_i(ip))
        interface.destroy
        @o += "#{ip} was successfully deleted.\n"
      rescue Exception => e
        @o += "<font color='red'>Err</font>:#{ip} #{e.message} failed deletion.\n"
      end
      
    end
    render :template => "mass_import/mass_server.html.erb"
  end

  def mass_subnet
    @o = ''
    
    # Parse the textarea with each newline
    data = params[:mass_import][:data].split("\r\n")
    
    # Parse each row in the text area
   for i in data
      j = i.split(",")
      # Strip out the space before and after hostname & IP
      colo_name = j[0].lstrip.rstrip.downcase
      vlan_name = j[1].lstrip.rstrip
      subnet = j[2].lstrip.rstrip
      colo = Colo.find_or_create_by_name(colo_name)
      vlan = Vlan.find_by_name(vlan_name)

      if ! vlan = Vlan.find_by_name(vlan_name)
        @o += "<font color='red'>Err</font>: vlan #{vlan_name} was not found.\n"
        next
      end

      vd = VlanDetail.new
      vd.colo = colo
      vd.vlan = vlan

      # Check for valid subnet
      begin
        cidr = NetAddr::CIDR.create(subnet)
        vd.subnet = subnet
        vd.save!
        @o += "#{vd.colo.name} -> #{vd.vlan.name} #{vd.subnet} was successfully added.\n"
      rescue NetAddr::ValidationError => e
        @o += "<font color='red'>Err</font>: invalid subnet #{subnet}: #{e.message} #{e.inspect}\n"
        next
      rescue Exception => e
        @o += "<font color='red'>Err</font>: #{colo_name} #{vlan_name} failed: #{e.message}\n"
        next
      end
    end
    render :template => "mass_import/mass_server.html.erb"
  end
  
end
