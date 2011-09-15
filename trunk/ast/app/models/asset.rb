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
class Asset < ActiveRecord::Base

  # Index records
  acts_as_solr :include => [:colo],
               :additional_fields => [:colo, :audit_changes, :dns_cname_details, {:mem => :integer}, {:disk => :integer},:cpu]  
  
  # This makes it a parent for anything that belongs to resource of Asset such as server, storage, pdu, and etc...
  belongs_to :resource, :polymorphic => true
  
  # Relationship to disk
  has_many :disk_details, :dependent => :destroy
  has_many :disk_models, :through => :disk_details
    
  # Relationship table with memory
  has_many :memory_details, :dependent => :destroy
  has_many :memory_models, :through => :memory_details
  
  # Relationship table with cpu
  has_many :cpu_details, :dependent => :destroy
  has_many :cpu_models, :through => :cpu_details

  # Network interfaces
  has_many :interfaces, :dependent => :destroy

  # Belongs to colo
  belongs_to :colo

  # To see which vips belong to this asset
  has_many :vips_pointing_to_me, :foreign_key => "hoster_id"

  # Relationship see which vip a server belongs to asset and destroy those relationship when asset is wiped.
  has_many :vip_servers, :foreign_key => "vip_asset_id", :dependent => :destroy
  
  # Find which real server an asset has
  has_many :servers_behind_me, :through => :vip_servers, :source => :asset, :foreign_key => "vip_asset_id"
  
  has_many :vip_before_me, :through => :vip_servers, :source => :asset, :foreign_key => "asset_id"
  
  # Added cname relationship from asset side
  has_many :dns_cname_details, :dependent => :destroy
  has_many :dns_cnames, :through => :dns_cname_details
  
  # define asset types  
  TYPES = ['servers','storages','pdus','networks','vips']

  # CONSTANT for states
  STATES = {
    :new => '1',
    :provision => '2',
    :free => '3'}

  # Validation method
  validates_uniqueness_of :name
  validates_presence_of :name
  
  # List out the changes so solr can index them
  def audit_changes()
    changes = []
    for a in self.audits
      for change in a.changes 
        if a.action == 'update' 
          if change[1][0] != nil
            changes << change[1][0]
          end
          if change[1][1] != nil
            changes << change[1][1]
          end
        else 
          if change[1] != nil
            changes << change[1]
          end
        end
      end
    end
    changes
  end

  def disk_count()
    disk_details.sum(:cnt)
  end  
  
  # Total disk size
  def disk()
    disk_count() / 1000
  end
  
  def memory_count()
    memory_models.sum(:capacity)
  end
  
  def mem()
    memory_count() / 1000
  end
  
  # VIP function.  Find out what real server is serving behind this vip(self).
  def server_behind_me_ids()
    @ids = []
    for o in vip_servers
      @ids << o.asset_id
    end
    @ids
  end
  
  # Find non-drac ip.
  def non_drac_interfaces
    new_interfaces = []
    
    for interface in interfaces
      if ! interface.drac_ip?
        new_interfaces << interface  
      end
    end
    
    new_interfaces
  end

  # Find non-drac ip.
  def drac_interface
    
    for interface in interfaces
      if interface.drac_ip?
        return interface  
      end
    end
    
    return nil
  end

  # Give us a primary interface or nil
  def primary_interface()
    # Special treatment for vip
    if resource_type == 'Vip'
      return resource.interface     
    else
      if non_drac_interfaces.nil?
        return nil
      
      # Only one interface, then just return it
      elsif non_drac_interfaces.length == 1
        
        return non_drac_interfaces[0]
      else
        # So if there are multiple interface and none is marked primary, we don't return anything.
        # We rather have no ip and debug than having some incorrect ip.
        for interface in non_drac_interfaces
          if interface.real_ip
            return interface
          end
        end
        #flash[:error] += "Multiple IP without any marked as primary"
        return nil
      end      
    end
  end  
  
  # Give us a primary interface or nil
  def primary_interface_including_drac()


    for interface in interfaces
        return interface
    end
    #flash[:error] += "Multiple IP without any marked as primary"
    return nil

  end   

  def com_or_int
    self.name.split('.')[-1]
  end

  def convert_to_drac_name()
    name_parts = self.name.split(".")
    name_parts[0] = name_parts[0] + "-d"
    if name_parts[-1] =~ /com/
      name_parts[-1] = 'int'
    end
    drac_name = name_parts.join(".")
  end

  def cpu()
    if ! self.cpu_models[0].nil?
      self.cpu_models[0].ctype
    end
  end

end
