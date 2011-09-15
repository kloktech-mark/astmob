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
class Server < AstBase

  # Index records
  acts_as_solr :include => [:server_model]

  belongs_to :server_model
  #validates_uniqueness_of :service_tag <== Maybe apply this after data is scrubbed.

  # Find if asset got drac IP
  def got_drac
    for i in asset.interfaces
      if i.vlan_detail.vlan.drac
        return i
      end
    end
    return nil
  end
  
  # Return unit for rack
  def unit
    self.server_model.unit
  end

  def update_service_tag(ocs_server, msg)
    ast_service_tag = service_tag
    ocs_service_tag = ocs_server.ocs_bio.SSN
    if ast_service_tag != ocs_service_tag
      if ast_service_tag.blank?
        ast_service_tag = "0"
      end
      self.update_attributes(:service_tag => ocs_service_tag)
      msg << "service tag: " + ast_service_tag + " => " + ocs_service_tag + ". "
    end
    return msg
  end
  
  def update_server_bios(ocs_server, msg)
  ast_server_bios = bios_version
  ocs_server_bios = ocs_server.ocs_bio.BVERSION
    if ast_server_bios != ocs_server_bios
      if ast_server_bios.blank?
        ast_server_bios = "0"
      end
      self.update_attributes(:bios_version => ocs_server_bios)
      msg << "server bios: " + ast_server_bios + " => " + ocs_server_bios + ". "
    end
    return msg
  end

  def update_server_model(ocs_server, msg)
    ocs_server_manufacturer = ocs_server.ocs_bio.SMANUFACTURER
    ocs_server_model = ocs_server.ocs_bio.SMODEL
    a = ServerModel.find_or_create_by_manufacture_and_model(ocs_server_manufacturer,ocs_server_model)
    #if a.blank?
    #  puts "initial"
    #  a = "1"
    #  initial_server_manufacturer = "UNKNOWN"
    #  inital_server_model = "UNKNOWN"
    #end
    # Put this block of code in to handle if the server_model got deleted from the dB
    if ! a[:id].blank?
      server_model_id = a[:id]
    end

    if self[:server_model_id] != a[:id]
      if server_model_id == 0 or server_model_id.blank?
        puts server_model_id.inspect
        initial_server_manufacturer = "NULL"
        initial_server_model = "NULL"
      else
        if server_model.blank?
          initial_server_manufacturer = "NULL"
          initial_server_model = "NULL"
        else
          initial_server_manufacturer = server_model.manufacture
          initial_server_model = server_model.model
        end
      end
      self.update_attributes(:server_model_id => a[:id])
      cur_server_manufacturer = server_model.manufacture
      cur_server_model = server_model.model
      if initial_server_manufacturer != cur_server_manufacturer or initial_server_model != cur_server_model
        msg << "server model: " + initial_server_manufacturer + " " + initial_server_model + " => " + cur_server_manufacturer + " " + cur_server_model + ". "
      end
    end  
  return msg
  end
  
  def update_notes(cur_time, msg)
    initial_note = asset.ocs_history
    if initial_note.blank?
      initial_note = ''
    end
    @header = cur_time.to_s
    add_on = @header + msg
    updated_note = "<< " + add_on + " >> " + "\n" + initial_note
    # Remove ocs_history update due to suspiction of corrupting db table.  It's a bug with mysql, but hard to reproduce.
#    asset.update_attribute(:ocs_history, updated_note)
  end
end
