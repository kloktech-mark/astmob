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
        Networking.get_an_ip(@server.asset,vlan_detail.id)

        @asset.primary_interface.update_attribute(:mac, mac)
        
        # And we will also assign a ip to destination 
        @o += "Server was successfully created.\n"
      else
        @o += "#{name} FAILED with \"#{@server.asset.errors.full_messages}\" \n"
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
        Networking.get_an_ip(@server.asset,vlan_detail.id)
        
        # And we will also assign a ip to destination 
        @o += "Server was successfully created.\n"
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

  # Import Nagios Services
  def nagios_service
    @o = ''
    # Take text input from mass_import params split by new line.
   
    # Parse the textarea with each newline
    data = params[:mass_import][:data].split("\r\n")
    hostgroup_map = nagios_hostgroup_map()
    
    # Parse each row in the text area
    for i in data
      
      j = i.split("||")
      # Strip out the space before and after hostname & IP
      name = j[0].lstrip.rstrip
      template = j[1].lstrip.rstrip
      host_name = j[2].lstrip.rstrip
      check_command = j[3].lstrip.rstrip

      # See if the service exist already
      service = NagiosService.find(:first, :conditions => "name = '#{name}' and check_command = '#{check_command}'")
      
      if service.nil?
        #@o += "FOUND #{host_name} #{name} (#{template}) - #{check_command.slice!(0..30)}\n"

        service = NagiosService.new(:name => name, :check_command => check_command)
        service_template = NagiosServiceTemplate.find_or_create_by_name(template)
        service.nagios_service_template = service_template
    
        # If asset is not found in ast, skip it with error message
        if service.save
          @o += "#{name} added.\n"
        else
          @o += "#{name} failed.\n"
        end
      end
      
      # Now we add the relationship between host and service

      
      hostgroup = nagios_find_my_hostgroup(host_name,hostgroup_map)
      
      if ! hostgroup.nil?
        service_detail = NagiosServiceDetail.find_or_create_by_nagios_host_group_id_and_nagios_service_id(hostgroup.id,service.id)
      else
        @o += "#{host_name} not found in any hostgroup.\n"
      end
      
    end
    
    if @o.empty?
      @o += "All service/host imported correctly.\n"
    end
  end
  
  # Import Nagios Services Escalation
  def nagios_service_escalation
    @o = ''
    # Take text input from mass_import params split by new line.
   
    # Parse the textarea with each newline
    data = params[:mass_import][:data].split("\r\n")
    
    hostgroup_map = nagios_hostgroup_map()
    
    #@o += hostgroup_map.inspect
    
    # Parse each row in the text area
    for i in data

      j = i.split("||")
      # Strip out the space before and after hostname & IP
      template = j[0].lstrip.rstrip
      host_name = j[1].lstrip.rstrip
      service_description = j[2].lstrip.rstrip
      contact_groups = j[3].lstrip.rstrip.split(",")
      
      service_escalation_template = NagiosServiceEscalationTemplate.find_or_create_by_name(template)
      
      # Find service 
      service = NagiosService.find_by_name(service_description)
       
      # Find hostgroup
      hostgroup = nagios_find_my_hostgroup(host_name,hostgroup_map)

      if hostgroup.nil? || service.nil?
        #@o += "ERROR: Couldn't find hostgroup for #{host_name}.\n"
        
      else
        #@o += "found #{host_name} in group  #{hostgroup.name}.\n"

        service_detail = NagiosServiceDetail.find(:first, :conditions => "nagios_host_group_id = #{hostgroup.id} AND nagios_service_id = #{service.id}")
        
        # If we found service_detail, let add the escalation
        if ! service_detail.nil?
          # Let's see if we already created.
          service_escalation = NagiosServiceEscalation.find(:first, :conditions => "nagios_service_detail_id = '#{service_detail.id}' AND nagios_service_escalation_template_id = '#{service_escalation_template.id}'")
          
          
          if service_escalation.nil?
            service_escalation = NagiosServiceEscalation.create(:nagios_service_detail_id => service_detail.id, :nagios_service_escalation_template_id => service_escalation_template.id)
            
            # Find the contact group and link them to this service escalation
            for contact_group in contact_groups 
              c = NagiosContactGroup.find_or_create_by_name(contact_group)
              NagiosContactGroupServiceEscalationDetail.create(:nagios_contact_group_id => c.id, :nagios_service_escalation_id => service_escalation.id)
            end
            
            @o += "#{hostgroup.name} with #{service_description} escalation added.\n"
          end          
        end

          
      end
      
      
    end
    
    render :template => "mass_import/nagios_service.html.erb"
  end
  
  
  # Import Nagios Services Escalation
  def nagios_service_group
    @o = ''
    # Take text input from mass_import params split by new line.
   
    # Parse the textarea with each newline
    data = params[:mass_import][:data].split("\r\n")
    
    hostgroup_map = nagios_hostgroup_map()
   
    # Parse each row in the text area
    for i in data

      j = i.split("||")
      # Strip out the space before and after hostname & IP
      servicegroup_name = j[0].lstrip.rstrip
      # even number = hostname, odd number = service name
      members = j[1].lstrip.rstrip.split(",")
      
      service_group = NagiosServiceGroup.find_or_create_by_name(servicegroup_name)
      
      count=0

      # Let's find member and associate it hostgroup + service to service group
      for i in members
        # if even number
        if ( count % 2 == 0 )
          hostgroup = nagios_find_my_hostgroup(i,hostgroup_map)
          h = i
        else
          service = NagiosService.find_by_name(i)
          
          if hostgroup.nil? or service.nil?
            @o += "ERR: either hostgroup or service is not found. #{h}:#{i}\n"
          else
            NagiosServiceGroupDetail.find_or_create_by_nagios_service_group_id_and_nagios_host_group_id_and_nagios_service_id(
                                            service_group.id,hostgroup.id,service.id)
            
#            NagiosServiceGroupDetail.create(:nagios_service_group => service_group, 
#                                            :nagios_host_group => hostgroup,
#                                            :nagios_service => service)
                       
          end
          
        end
        count = count + 1
      end

      
    end
    
    render :template => "mass_import/nagios_service.html.erb"
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
  
  
  
end
