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
class CpuDetail < ActiveRecord::Base
 
  belongs_to :asset
  belongs_to :cpu_model
  
  def update_cpu_model_from_ocs(ocs_server, msg)
    ocs_cpu_type = ocs_server.PROCESSORT
    ocs_cpu_speed = ocs_server.PROCESSORS
    a = CpuModel.find_or_create_by_speed_and_ctype(ocs_cpu_speed,ocs_cpu_type)
    if cpu_model_id != a[:id]
      if cpu_model_id == 0 || cpu_model_id == "NULL" || cpu_model_id.blank?
        initial_cpu_type = "NULL"
        initial_cpu_speed = 0.to_s
      else
        initial_cpu_type = cpu_model.ctype
        initial_cpu_speed = cpu_model.speed.to_s        
      end
      logger.info initial_cpu_type
      logger.info a.inspect
      self.update_attribute(:cpu_model_id, a[:id])      
      cur_cpu_type = cpu_model.ctype
      cur_cpu_speed = cpu_model.speed.to_s
      if initial_cpu_type != cur_cpu_type or initial_cpu_speed != cur_cpu_speed
        msg << "cpu model: " + initial_cpu_type + " " + initial_cpu_speed + " => " + cur_cpu_type + " " + cur_cpu_speed + ". "  
      end
    end    
    return msg
  end
  
  def update_cpu_cores_from_ocs(ocs_server, msg)
    ocs_cpu_cores = ocs_server.PROCESSORN
    if num_cores != ocs_cpu_cores
      self.update_attribute(:num_cores, ocs_cpu_cores)  
      if num_cores != ocs_cpu_cores
        msg << "cpu cores: " + num_cores.to_s + " => " + ocs_cpu_cores.to_s + ". "
      end
    end
    return msg
  end
end
