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
class OcsCronsController < ApplicationController
  
  # def refresh_demo_servers ( colo_name='development' )
  def pull_from_ocs 
    require 'networking'
    
    # output buffer
    @o = ''
    processed_counter = 0
    
    now = Time.now
    
    # Only find server that have been updated in the past two days
    for ocs_server in OcsHardware.find( :all , :conditions => "lastcome > '#{now.yesterday.to_s(:db)}'" )
      
      # Build hostname. Shortname + domain name
      ocs_server_name = ocs_server.NAME + '.' + ocs_server.WORKGROUP
      @o += "Processing #{ocs_server_name}.."
      
      # See if you already have asset of the same name.  If so, skip it
      if ( Asset.find_all_by_name(ocs_server_name).length > 0 )
        @o +=  "server already exists, no need to import again\n"
        next
      end
      
      #raise ocs_server.inspect
      
      # Find which vlan_detail owns this IP.
      vlan_detail = Networking.get_vlan_for_ip(ocs_server.IPADDR)
      if ( vlan_detail.nil?  )
        @o += "skiping because not able to find vlan " + ocs_server_name + "\n"
        next
      end
      
      #raise vlan_detail.inspect
      
      # Create new server
      server = Server.new()
      server.asset = Asset.new(:name => ocs_server_name)
      server.asset.colo = vlan_detail.colo
      
      bio = ocs_server.ocs_bio
      server.service_tag = bio.SSN
      server.bios_version = bio.BVERSION
      server.server_model = ServerModel.find_or_create_by_manufacture_and_model(bio.SMANUFACTURER,bio.SMODEL)
      
      if server.save
        @o += " save successfully.\n"
        processed_counter += 1
      else
        @o += "save failed.\n"
        raise "Server saved failed" + server.inspect
      end
      
      # Add each memory into asset
      for ocs_memory in ocs_server.ocs_memories
        
        # Fix up some text
        if ocs_memory.CAPACITY == "No"
          next
        end
        if ocs_memory.TYPE =='<OUT OF SPEC>'
          ocs_memory.TYPE = 'Unknown'
        end
        
        # Declare new detail and update its attribute, then save
        m = MemoryDetail.new();
        m.asset = server.asset
        m.memory_model = MemoryModel.find_or_create_by_speed_and_capacity_and_mtype(ocs_memory.SPEED,ocs_memory.CAPACITY,ocs_memory.TYPE)
        m.slot = ocs_memory.NUMSLOTS
   
      #raise server.asset.memory_details.inspect

      # Add each cpu into asset
      for ocs_cpu in ocs_server.ocs_cpus
        
        # Declare new detail and update its attribute, then save
        c = CpuDetail.new();
        c.asset = server.asset
        c.cpu_model = CpuModel.find_or_create_by_processort_and_processors(ocs_cpu.PROCESSORT,ocs_cpu.PROCESSORS)
        c.cores = ocs_cpu.PROCESSORN
        if ! c.save
          @o += "saving cpu failed. \n"
        end
      end
      
      # Process disk details
      for ocs_storage in ocs_server.ocs_storages_disk_only
        # p disk
        if ocs_storage.MANUFACTURER.nil?
          ocs_storage.MANUFACTURER = 'Unknown'
        end
        if ocs_storage.DISKSIZE.nil?
          ocs_storage.DISKSIZE = 0
        end
        
        # Get the disk_model
        disk_model = DiskModel.find_or_create_by_part_number_and_capacity_and_name(ocs_storage.MODEL,ocs_storage.DISKSIZE,ocs_storage.MANUFACTURER)
        
        d = DiskDetail.new()
        d.cnt = 1
        d.disk_model = disk_model
        d.asset = server.asset
        
        if ! d.save
          @o += "saving disk failed. \n"
        end        
      end
      
      
      # Go through each interface and find the IP.
      # Matter of fact, we should just use the ones listed in ocs_server.IPADDRESS
      # since they are the only interfaces with IP anyway.  Don't have to go through
      
      server_ips = []
      if ocs_server.IPADDR =~ /\//
        server_ips = ocs_server.IPADDR.split('/')
      else
        server_ips << ocs_server.IPADDR
      end
          

      # For each ip in server.
      for myip in server_ips
        
        # match against each row in interfaces
        for ocs_interface in ocs_server.ocs_interfaces
          
          # If ip matches and interface name looks ok, we'll save it
          if ( myip == ocs_interface.IPADDRESS && ocs_interface.DESCRIPTION =~ /bond0|eth/i && server.asset.interfaces.length < 1)
            i = Interface.new(:primary => true, :ip => myip)
            i.asset = server.asset
            i.name = ocs_interface.DESCRIPTION
            i.mac = ocs_interface.MACADDR
            i.vlan_detail = Networking.get_vlan_for_ip(myip)
            # If the ip can't be found in our vlan list, we will skip it.
            if i.vlan_detail.nil?
              next
            end

            # If saves successfully, we got our interface alraedy.
            if ( i.save )
              break
            else
              @o += "saving interface #{myip} failed. \n"
              @o += "IP = " + i.inspect
              #server.destroy
              next
            end
          # If not match, move on
          else
             next
          end
        end
      end
    end
    @o += "Processed #{processed_counter} out of " + OcsHardware.find( :all ).length.to_s + " servers.\n"
  end
  
end

def refresh_ast_intf (hardware_id, asset_id )
  @ocs_intf = OcsInterface.find(:hardware_id => hardware_id)
  for curr_intf in @ocs_intf
    nil
  end
end


def refresh_ast_servers
  # get servers list from ast 
  @asset_type = 'server'
  @colo_id    = 1
  @ast_servers = Asset.find(:all,
                            :conditions => [ 'resource_type = ? and colo_id = ?  ',@asset_type,@colo_id])
  
  for curr_server in @ast_servers
    ocs_server = OcsHardware.find( :all,
                                  :conditions => [ ' name = ? ',curr_server.NAME])
    
    # get storage details 
    # get network details 
    # get memory details
    # get cpu details
    
  end
  # get 
  
  #end
end
