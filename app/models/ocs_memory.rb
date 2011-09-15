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
class OcsMemory < OcsBase
  set_table_name "memories"
  
  belongs_to :ocs_hardware, :foreign_key => 'hardware_id'
  
  def update_memory_from_ocs(ast_mem, msg, server)
    ocs_mem_capacity = self[:CAPACITY]
    ocs_mem_type = self[:TYPE]
    ocs_mem_numslots = self[:NUMSLOTS]
    ocs_mem_speed = self[:SPEED]
    if ocs_mem_capacity == "No"
      ocs_mem_capacity = 0
    end
    a = MemoryModel.find_or_create_by_speed_and_mtype_and_capacity(ocs_mem_speed, ocs_mem_type, ocs_mem_capacity)
    if ast_mem.blank?
      cur_mem = MemoryDetail.new
      cur_mem.asset_id = server.asset.id  
      cur_mem.memory_model_id = 0
      cur_mem.save
    else
      cur_mem = ast_mem.shift
    end
    if cur_mem.memory_model_id != a[:id]
      if cur_mem.memory_model_id == 0
        initial_mem_speed = "Unknown"
        initial_mem_capacity = 0.to_s
      else
        initial_mem_speed = cur_mem.memory_model.speed
        initial_mem_capacity = cur_mem.memory_model.capacity.to_s
      end
      cur_mem.update_attributes(:memory_model_id => a[:id])
      cur_mem_speed = cur_mem.memory_model.speed
      cur_mem_capacity = cur_mem.memory_model.capacity.to_s
      if initial_mem_speed != cur_mem_speed or initial_mem_capacity != cur_mem_capacity
        msg << "mem model: " + initial_mem_speed + " " + initial_mem_capacity + " => " + cur_mem_speed + " " + cur_mem_capacity + ". "      
      end
    end
    if cur_mem.slot != ocs_mem_numslots
      initial_mem_slot = cur_mem.slot
      cur_mem.update_attributes(:slot => ocs_mem_numslots)
      msg << "mem slots: " + initial_mem_slot.to_s + " => " + ocs_mem_numslots.to_s + ". "
    end
    return msg      
  end
end
