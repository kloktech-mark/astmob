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
class PxeController < ApplicationController
  
  # Given colo as parameter, return a json with all the following:
  # hostname, ip, mac, netmask, dns1, dns2, gateway, drac hostname, drac ip, drac netmask. drac gatewau
  def fetch_colo
    
    @o = ''
    # zone name pass from url
    colo_name = params[:colo]
    boxes = []

    begin
      # Find all assets in server type in the given colo
      boxes = Colo.find_by_name(colo_name).assets.delete_if{|a| a.resource_type != 'Server'}
    rescue Exception => exc

    end

    # If no boxes are found, record error and done
    if boxes.length == 0 or boxes.nil?
      e = {}
      e['error'] = 'Invalid colo specified'
      @o = e.to_json
    else
      all_server = []
      for box in boxes.sort{|a,b| a.name <=> b.name}
        server = {}
        # primary_interface is used for machine with multiple interfaces like HA.
        if box.primary_interface.nil?
          server['hostname'] = box.name
          server['error'] = "No network defined"
          all_server << server
          next 
        end

        interface = box.primary_interface
        # If no mac is found, record the error and move on
        if interface.mac.nil?
          server['hostname'] = box.name
          server['error'] = "Mac not found."
          all_server << server
          next 
        end

        # downcase it to match tftp server
        server['mac'] = interface.mac.downcase
        server['hostname'] = box.name
        server['ip'] = interface.ip_to_string
        server['netmask'] = interface.vlan_detail.netmask
        server['gateway'] = interface.vlan_detail.gateway

        # Let's pick up drac interface.
        if box.drac_interface.nil?
          server['error'] = 'DRAC not found.'
        else
          drac_int = box.drac_interface
          drac = {}
          drac['ip'] = drac_int.ip_to_string
          
          # We convert '.com' to '.int' and add a '-d' in hostname.
          drac['hostname'] = box.convert_to_drac_name

          # Eval in case there is problem with finding gateway or netmask
          begin 
            drac['gateway'] = drac_int.vlan_detail.gateway
            drac['netmask'] = drac_int.vlan_detail.netmask
          rescue Exception => exc
            drac['error'] = exc.message
          end

          server['drac'] = drac
        end

        all_server << server
        
      end

      # All information populated, give it to output variable
      @o = all_server.to_json
    end
    render(:partial => "output",:object => @o) 
  end

  def fetch_dhcpd
    
    @o = ''
    # zone name pass from url
    colo_name = params[:colo]
    boxes = []

    begin
      # Find all assets in server type in the given colo
      boxes = Colo.find_by_name(colo_name).assets.delete_if{|a| a.resource_type != 'Server'}
    rescue Exception => exc

    end

    # If no boxes are found, record error and done
    if boxes.length == 0 or boxes.nil?
      e = {}
      e['error'] = 'Invalid colo specified'
      @o = e.to_json
    else
      all_server = {}
      # Populate array with colo's vlan
      Colo.find_by_name(colo_name).vlan_details.each{|vlan_detail|
        #raise vlan_detail.inspect
        name = vlan_detail.vlan.name
        all_server[name] = {}
        all_server[name]['boxes'] = []
        all_server[name]['netmask'] = vlan_detail.netmask
        all_server[name]['name'] = name
        all_server[name]['network'] = vlan_detail.network
        all_server[name]['routers'] = vlan_detail.gateway
      }
      for box in boxes.sort{|a,b| a.name <=> b.name}
        server = {}
        # primary_interface is used for machine with multiple interfaces like HA.
        if box.primary_interface.nil?
          server['hostname'] = box.name
          server['error'] = "No network defined"
          #all_server << server
          next 
        end

        interface = box.primary_interface
        # If no mac is found, record the error and move on
        if interface.mac.nil?
          server['hostname'] = box.name
          server['mac'] = ""
          #server['error'] = "Mac not found."
          all_server[interface.vlan.name]['boxes'] << server
          next 
        end

        # downcase it to match tftp server
        server['mac'] = interface.mac.downcase
        server['hostname'] = box.name
        server['ip'] = interface.ip_to_string

        all_server[interface.vlan.name]['boxes'] << server

        # Let's pick up drac interface.
        if box.drac_interface.nil?
          server['error'] = 'DRAC not found.'
        else
          drac_int = box.drac_interface
          drac = {}
          drac['ip'] = drac_int.ip_to_string
          drac['mac'] = drac_int.mac
          
          # We convert '.com' to '.int' and add a '-d' in hostname.
          drac['hostname'] = box.convert_to_drac_name

          # Eval in case there is problem with finding gateway or netmask
          begin 
            drac['gateway'] = drac_int.vlan_detail.gateway
            drac['netmask'] = drac_int.vlan_detail.netmask
          rescue Exception => exc
            drac['error'] = exc.message
          end

          # Put drac under drac vlan
          all_server[drac_int.vlan.name]['boxes'] << drac
        end
        
      end

      # All information populated, give it to output variable
      @o = all_server.to_json
    end
    render(:partial => "output",:object => @o) 
  end
end
