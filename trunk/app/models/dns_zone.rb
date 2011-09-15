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
class DnsZone < ActiveRecord::Base
  
  belongs_to :inherit_from, :class_name => "DnsZone", :foreign_key => "inherit"
  has_many :dns_ns_records, :dependent => :destroy
  has_many :dns_mx_records, :dependent => :destroy
  
  validates_presence_of :name
  
  # All the following my_* function is to have inheritance working.
  # It checks if value exist on self first, if not, take it from its inherited value.
  
  def my_soa
    if self.soa.empty?
      self.inherit_from.my_soa
    else
      self.soa
    end
  end
  
  def my_refresh
    if self.refresh.to_s.empty?
      self.inherit_from.my_refresh
    else
      self.refresh
    end
  end

  def my_retry
    if self.retry.to_s.empty?
      self.inherit_from.my_retry
    else
      self.retry
    end
  end

  def my_expire
    if self.expire.to_s.empty?
      self.inherit_from.my_expire
    else
      self.expire
    end
  end
  
  def my_minimum
    if self.minimum.to_s.empty?
      self.inherit_from.my_minimum
    else
      self.minimum
    end
  end
  
  def my_dns_ns_records
    if self.dns_ns_records.empty?
      if ! self.inherit_from.nil?
        return self.inherit_from.my_dns_ns_records
      end
    else
      return self.dns_ns_records
    end
    return []
  end

  def my_dns_mx_records
    if self.dns_mx_records.empty?
      if ! self.inherit_from.nil?
        return self.inherit_from.my_dns_mx_records
      end      
    else
      return self.dns_mx_records
    end
    return []    
  end

  def my_ttl
    if self.ttl.to_s.empty?
      self.inherit_from.my_ttl
    else
      self.ttl
    end
  end
  
end
