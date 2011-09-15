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
class VlanDetail < ActiveRecord::Base
  require 'networking'

  belongs_to :colo
  belongs_to :vlan
  
  has_many :interfaces, :dependent => :destroy
  
  validates_presence_of :colo_id
  validates_presence_of :vlan_id
  validates_presence_of :subnet

  # To handle special drac case where subnet is broken into two subnet in AST but not in actual host configuratino.  It was done that way so drac and network equipment have their own clean subnet
  def subnet_of_same_vlan()
     
    # We want to do this with drac only, so this would be one hard coded vlan number here
    # This is unlikely to change as long as we are still using drac
    if self.vlan.vlan_number != 200
      return self.subnet
    end

    other_vlans = Vlan.find(:all, :conditions => "vlan_number = #{self.vlan.vlan_number}")
    if other_vlans.class != Array
      return self.subnet
    else 
      other_vlan_ids = other_vlans.collect{|x| x.id}
      other_subnet = VlanDetail.find(:all, :conditions => "colo_id = #{self.colo_id} AND (vlan_id = #{self.vlan_id} or vlan_id in (#{other_vlan_ids.join(',')}))").collect! {|v| v.subnet}.join(",")
    end
  end

  def gateway()
    Networking.gateway(self.subnet_of_same_vlan)
  end

  def netmask()
    Networking.netmask(self.subnet_of_same_vlan)   
  end

end
