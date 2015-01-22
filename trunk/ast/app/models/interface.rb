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
class Interface < ActiveRecord::Base

  acts_as_solr :additional_fields => [:find_ip]
  
  belongs_to :asset
  # audit from http://github.com/kennethkalmer/acts_as_audited/tree/master
  #acts_as_audited :parent => :asset
  
  belongs_to :vlan_detail
  
  has_many :vips, :dependent => :destroy
  
  validates_uniqueness_of :ip
#  validates_uniqueness_of :ip_v6
  validates_presence_of :vlan_detail_id, :message => "Ip #{} doesn't belong to any vlan."

  require 'networking'

  def before_validation
    
    # Get the original attributes before type cast
    orig_attr = self.attributes_before_type_cast

    if orig_attr['ip'].nil? or orig_attr['ip'].empty?
      raise "Need to input IP"
    end

    # Convert the ip to integer
#    begin
      if orig_attr['ip'] =~ /\./
        self.ip = Networking.ip_to_i(orig_attr['ip'])
      end
#    rescue
#    end

    # Check if vlan_detail is set, if not, let's find it 
    if self.vlan_detail_id.nil?
      self.vlan_detail = Networking.get_vlan_for_ip(orig_attr['ip'])

      if self.vlan_detail.nil?
        raise "IP doesn't belong to any vlan"
      end
      if self.vlan_detail.colo != self.asset.colo and self.vlan_detail.colo.backbone == false
        raise "IP belongs to colo " + self.vlan_detail.colo.name + " not " + self.asset.colo.name
      end
      if ( ! (orig_attr['ip_v6'].nil? or orig_attr['ip_v6'].empty?) ) 
        v6_vlan_detail = Networking.get_vlan_for_ip(orig_attr['ip_v6'])
        if self.vlan_detail != v6_vlan_detail
          raise "IP and IPv6 belongs to different colo->vlan definition"
        end
      end
    end
  end

  def find_ip
    self.ip_to_string
  end

  # Convert ip to string
  def ip_to_string 
    Networking.i_to_ip self.ip    
  end

  # Convert integer to ip
  def self.i_to_ip(i)
    Networking.i_to_ip i
  end
  
  # Convert ip to interger
  def self.ip_to_i(ip)
    Networking.ip_to_i(ip)
  end
  
  def drac_ip?
    if self.vlan_detail.vlan.drac
      return true
    else
      return false
    end
  end

  def vlan
    self.vlan_detail.vlan
  end

end
