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
class Pdu < AstBase
  
  require 'snmp'
  
  belongs_to :pdu_model
  
  validates_presence_of :pdu_model
  

  # Get amp usage from pdu using oid defined in pdu_model
  def get_amp
    # If interface is defined
    if ! self.asset.primary_interface_including_drac.nil?
        
      SNMP::Manager.open(:Host => self.asset.primary_interface_including_drac.ip_to_string, 
                         :Community => self.pdu_model.snmp_read,
                         :Timeout => 1,
                         :Retries => 0) do |snmp|
        begin
          # Return this value divided by 10 to get real amp reading.  Other PDU might be different,
          # We will figure it out later
          return snmp.get_value(self.pdu_model.oid_load).to_i / 10
        rescue Exception => exc
          # do nothing
          return nil
        end     
        
      end
    end
  end
  
  def unit
    self.pdu_model.unit
  end
end
