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
class OcsBase  < ActiveRecord::Base

  # Abstract class for all ocs models, it doesn't need to map to a database.
  # We use it just for setting some default parameters for ocs models
  #def initialize (colo='development')
    self.abstract_class = true
  
    require 'yaml'
  
   # Find the ocs portion of config in database.yml
     ocs_config = YAML.load(File.open(File.join(RAILS_ROOT,"config/database.yml"),"r"))["ocs_"+ ENV['RAILS_ENV']]
    # ocs_config = YAML.load(File.open(File.join(RAILS_ROOT,"config/database.yml"),"r"))["ocs_" + colo ] 
   #p " debug 1 "
  #  p ocs_config
   establish_connection(ocs_config)
  
  # OCS primary key is capitalized "ID"
  self.primary_key = "ID"
# end

end
