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
class OcsInterface < OcsBase
  set_table_name "networks"
  
  belongs_to :ocs_hardware, :foreign_key => 'hardware_id'
  
  def update_mac_from_ocs(ast_nic, msg)
    ocs_ip = self[:IPADDRESS]
    ocs_mac = self[:MACADDR]
    ast_nic.each do |i|
      if ocs_ip == i.ip_to_string
        if ocs_mac != i.mac          
          initial_mac = i.mac
          i.update_attribute(:mac, ocs_mac)
          cur_mac = i.mac
          if initial_mac != cur_mac
            msg << "MAC: " + i.mac + " => " + ocs_mac + ". "
          end    
          @ip_good = 1
        else
          @ip_good = 1
        end
      end
    end
    if @ip_good.blank?
      msg << "WARN: IP mismatch."
    end
    return msg
  end  
end
