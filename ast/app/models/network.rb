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
class Network < AstBase
  require 'snmp'

  # Index records
  acts_as_solr :include => [:network_model]
  
  belongs_to :network_model

  attr_accessor :total_port
  
  #return unit for racking
  def unit
    self.network_model.unit
  end
  
  
  
  def open_port
    total = 0
    up_port = 0
      
    if ! self.asset.primary_interface_including_drac.nil?
      SNMP::Manager.open(:Host => self.asset.primary_interface_including_drac.ip_to_string, 
                         :Community => 'secretCommunity',
                         :Timeout => 1,
                         :Retries => 0) do |snmp|
  
        # Catch exception is host is not reachable.
        begin
          # Walk the IF-MIB::ifOpoerStatus
          snmp.walk('1.3.6.1.2.1.2.2.1.8') do |row|
            row.each { |vb| 
              
              # This math is for cisco afaik, port lower than 10000 is vlan.
              if vb.name.to_s.sub(/1\.3\.6\.1\.2\.1\.2\.2\.1\.8./, '').to_i > 10000 && vb.name.to_s.sub(/1\.3\.6\.1\.2\.1\.2\.2\.1\.8./, '').to_i < 10500
                total += 1
                if vb.value == 1
                  up_port += 1
                end
               
              end
              
            }
          end
        
        rescue Exception => exc
          # do nothing
          return nil
        end
        
      end
    #raise total_port.inspect + " " + up_port.inspect
    self.total_port = total
    return total - up_port 

    end

  else
    return nil
  end
  
end
