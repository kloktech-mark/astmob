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
class OcsHardware < OcsBase
  #def initialize(colo='development')
    
  # super(colo)
  set_table_name "hardware"
  
  has_many :ocs_cpus, :foreign_key => 'HARDWARE_ID'

  has_many :ocs_memories, :foreign_key => 'HARDWARE_ID'
  
  has_many :ocs_storages, :foreign_key => 'HARDWARE_ID'
  
  has_many :ocs_interfaces, :foreign_key => 'HARDWARE_ID'

  has_one :ocs_bio, :foreign_key => 'HARDWARE_ID'
  
  
  # We only want disk, no floppy, no cdrom, dvdrom nor blueray
  def ocs_storages_disk_only
    disks = []
    for o in ocs_storages
      if o.TYPE == 'disk'
        disks << o
      end
    end
    disks
  end
  
  def self.table_name
    "ocsweb.hardware"
  end
end
