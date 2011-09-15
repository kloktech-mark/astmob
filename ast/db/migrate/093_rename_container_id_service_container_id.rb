class RenameContainerIdServiceContainerId < ActiveRecord::Migration
  def self.up
   rename_column :service_check_details, :container_id, :service_container_id

  end

  def self.down
    rename_column :service_check_details, :service_container_id, :container_id 
  end
end