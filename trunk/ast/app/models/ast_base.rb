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
class AstBase < ActiveRecord::Base

  # Abstract class for all ocs models, it doesn't need to map to a database.
  # We use it just for setting some default parameters for ocs models
  self.abstract_class = true  
  has_one :asset, :as => :resource, :dependent => :destroy

  # Also validates associates asset
  validates_associated :asset
  
  def name
    asset.name
  end
  
  def colo
    asset.colo
  end
  
  def resource_type
    asset.resource_type
  end
  
  def resource
    asset.resource
  end
  
  def resource_id
    asset.resource_id
  end
  
  def my_ip
    asset.primary_interface.ip_to_string
  end

  
end
