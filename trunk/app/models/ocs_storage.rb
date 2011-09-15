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
class OcsStorage < OcsBase
  set_table_name "storages"
  belongs_to :ocs_hardware, :foreign_key => 'hardware_id'

  def update_storage_from_ocs(ast_disk, msg, server)
    ocs_disk_manufacturer = self[:MANUFACTURER]
    ocs_disk_name = self[:NAME]
    ocs_disk_model = self[:MODEL]
    ocs_disk_description = self[:DESCRIPTION]
    ocs_disk_disksize = self[:DISKSIZE]
    a = DiskModel.find_or_create_by_name_and_capacity_and_part_number_and_drivetype(ocs_disk_manufacturer, ocs_disk_disksize, ocs_disk_model, ocs_disk_description)
    if ast_disk.blank?
      cur_disk = DiskDetail.new
      cur_disk.asset_id = server.asset.id  
      cur_disk.disk_model_id = 0
      cur_disk.save
    else
      cur_disk = ast_disk.shift
    end
    if cur_disk.disk_model_id != a[:id]
      if cur_disk.disk_model_id == 0
        initial_disk_name = "NULL"
        initial_disk_capacity = 0.to_s
        initial_disk_part_number = "NULL"
        initial_disk_drivetype = "NULL"        
      else
        initial_disk_name = cur_disk.disk_model.name
        initial_disk_capacity = cur_disk.disk_model.capacity.to_s
        initial_disk_part_number = cur_disk.disk_model.part_number
        initial_disk_drivetype = cur_disk.disk_model.drivetype        
      end
      cur_disk.update_attributes(:disk_model_id => a[:id])
      cur_disk_name = cur_disk.disk_model.name
      cur_disk_capacity = cur_disk.disk_model.capacity.to_s
      cur_disk_part_number = cur_disk.disk_model.part_number
      cur_disk_drivetype = cur_disk.disk_model.drivetype 
      if initial_disk_name != cur_disk_name or initial_disk_capacity != cur_disk_capacity or initial_disk_part_number != cur_disk_part_number or initial_disk_drivetype != cur_disk_drivetype
        msg << "Disks: " + initial_disk_name + " " + initial_disk_capacity + " " + initial_disk_part_number + " " + initial_disk_drivetype + " => " + cur_disk_name + " " + cur_disk_capacity + " " + cur_disk_part_number + " " + cur_disk_drivetype + ". "
      end
    end
    if cur_disk.scsiid != ocs_disk_name
      if cur_disk.scsiid.blank?
        initial_scsiid = "0"
      else
        initial_scsiid = cur_disk.scsiid
      end
      cur_disk.update_attributes(:scsiid => ocs_disk_name)
        msg << "Scsi ID: " + initial_scsiid + " => " + ocs_disk_name + ". "
    end   
    return msg  
  end
end
