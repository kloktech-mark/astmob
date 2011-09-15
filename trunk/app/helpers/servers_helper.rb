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
module ServersHelper
  
  # Testing function to see how we pull information from ocs.
  def check_ocs
    @server = Server.new(params[:server])
    @server.asset = Asset.new(params[:asset])
    flash[:error] = ''
    
    begin
      ip = IPSocket.getaddress(params[:asset][:name])
    rescue Exception => exc
      flash[:error] = "Error in resolving #{params[:asset][:name]}"
    end
    
    @ocs_hardware = OcsHardware.find_all_by_NAME(@server.asset.name)
    
    #It should only return one
    if @ocs_hardware.length > 1
      raise "Multiple machine with same IP"
    end
    
    if @ocs_hardware.length == 1
      @hardware = @ocs_hardware[0]
      
      # What we should do instead of doing the query per asset, during the mass import
      # or nightly update, we should update our server model table before we actually pull 
      # any information

      # We will create the new model if it doesn't already exist in our database
      bio = @hardware.ocs_bio
      if ServerModel.find_all_by_manufacture_and_model(bio.SMANUFACTURER,bio.SMODEL).length == 0
        server_model = ServerModel.new(:manufacture => bio.SMANUFACTURER, :model => bio.SMODEL )
        if !server_model.save 
          flash[:error] = "Unable to create new model"
        end
      end
      
      memories = @hardware.ocs_memories
      for memory in memories
        if memory.SPEED != 'Unknown'
          if MemoryModel.find_all_by_speed_and_capacity_and_mtype(memory.SPEED,memory.CAPACITY,memory.TYPE).length == 0
            if !MemoryModel.create(:speed => memory.SPEED, :capacity => memory.CAPACITY, :mtype => memory.TYPE )
              flash[:error] = "Unable to create new memory"
            end
          end
        end
      end
    end
    
    
    respond_to do |format|
      format.html { render :partial => 'check_ocs', :layout => false, :object => @server }
      format.xml  { render :xml => @server }
    end
  end
  
end
