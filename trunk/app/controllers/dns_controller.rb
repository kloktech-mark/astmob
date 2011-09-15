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
class DnsController < ApplicationController
  
  require 'networking'

  # Build a dns with drac ip
  def drac
    
    # Initializa output
    @o = ''
    
    colo_name = params[:colo]
    record_type = params[:record_type]?params[:record_type]:"a"
    
    colo = Colo.find(:first, :conditions => "name = '#{colo_name}'")

    if colo.nil?
      @o = "ERROR: Need do supply a colo name.  Possible choices are " + Colo.find(:all,:select => :name).sort{|a,b| a.name<=>b.name}.collect{|a| a.name}.join(",")
      
    else
      
      assets = Asset.find(:all, :conditions => "colo_id = #{colo.id}")
      
      # Loop through asset, find their drac and output A and PTR record.
      @o += ";DRAC in #{colo.name}\n"
      for asset in assets.sort{|a,b| a.name<=>b.name}

        # If asset have drac interface and is a server
        if ! asset.drac_interface.nil? and asset.resource_type == "Server"
        
          if record_type == "a"
  
            short = asset.name.split(".")[0] + "-d"  
            @o += "#{short}\tA\t#{asset.drac_interface.ip_to_string}\n"
            
          elsif record_type == "ptr"
            # Get the name split up, we need to add "-d" to the name
            name_arr = asset.name.split(".")
            ptr_name = name_arr[0] + "-d"
            # concatenate rest of the name
            (1..name_arr.length - 1).each do |i|
              ptr_name += "." + name_arr[i]
            end
            
            # Get the ip converted to string, then put them in right order for PTR record
            ip_string = asset.drac_interface.ip_to_string 
            ptr_ip = ip_string.split(".")[3] + "." + ip_string.split(".")[2]

            
            @o += "#{ptr_ip}\tPTR\t#{ptr_name}.\n"
          end
        end
      end
      @o += ";END DRAC in #{colo.name}\n"
      
    end

    # Render without layout so we can use it to generate dns
    render :partial => 'default', :layout => false, :object => @o

    
  end
end
