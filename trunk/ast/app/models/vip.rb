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
class Vip < AstBase

  # Index records
  acts_as_solr
  
  belongs_to :hoster, :class_name => "Asset", :foreign_key => "hoster_id"

  belongs_to :interface

  validates_presence_of :port

  def colo
    self.hoster.colo
  end
  # define asset types  
  PROTOS = ['tcp','udp']
  
end
