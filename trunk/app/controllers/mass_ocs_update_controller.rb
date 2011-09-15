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
class MassOcsUpdateController < ApplicationController
  require 'networking'

  def index
    @server = Server.find(:all)
    @server.each do |z|
    cur_time = Time.now
    @o = Array.new
 
    #build the correct name for OCS then get the OCS object
    @ocs_server = OcsHardware.find(:first, :conditions => ["deviceid = ?", z.name])
    if ! @ocs_server.blank?
      ## Populate the AST variables
      @ast_cpu = CpuDetail.find(:first, :conditions => ["asset_id = ?", z.asset.id ])
      @ast_disk = DiskDetail.find(:all, :conditions => ["asset_id = ?", z.asset.id ])
      @ast_memory = MemoryDetail.find(:all, :conditions => ["asset_id = ?", z.asset.id ])
      @ast_nic = Interface.find(:all, :conditions => ["asset_id = ?", z.asset.id ])
    
      ## Populate the OCS variables 
      @ocs_storage_devices = OcsStorage.find(:all, :conditions => ["hardware_id = ?", @ocs_server.id])
      @ocs_memory_modules = OcsMemory.find(:all, :conditions => ["hardware_id = ?", @ocs_server.id])
      @ocs_nics = OcsInterface.find(:all, :conditions => ["hardware_id =?", @ocs_server.id])

      #check if AST fields exist, then update or create AST fields with OCS data
      ## Update CPU info
      if @ast_cpu.blank?
        b = CpuDetail.new
        b.asset_id = z.asset.id
        b.cpu_model_id = 0
        b.save
        @ast_cpu = CpuDetail.find(:first, :conditions => ["asset_id = ?", z.asset.id ])
      end
      @o = @ast_cpu.update_cpu_model_from_ocs(@ocs_server, @o)
      @o = @ast_cpu.update_cpu_cores_from_ocs(@ocs_server, @o)
        
      ##Update Service Tag
      @o = z.update_service_tag(@ocs_server, @o)
      
      ##Update Bios Version
      @o = z.update_server_bios(@ocs_server, @o)
      
      ##Update Server Model/Manufacturer
      @o = z.update_server_model(@ocs_server, @o)
      
      ##Update Storage
      myDisks = Array.new
      @ocs_storage_devices.each do |i|
        if i.TYPE == "disk"
          myDisks << i
        end
      end
      myDisks.each do |i|
        @o = i.update_storage_from_ocs(@ast_disk, @o, z)
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
        @o = i.update_memory_from_ocs(@ast_memory, @o, z)
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
      #flash[:notice] = @o
    elsif @o == "not_in_ocs"
      @o = cur_time.to_s + ": Server not found in OCS. Doing nothing."
      z.update_notes(cur_time.to_s, @o.to_s)
      #flash[:notice] = @o     
    else
      z.update_notes(cur_time.to_s, @o.to_s)
      #flash[:status] = @o
    end

    end
    redirect_to :controller => 'servers'
  end
end
