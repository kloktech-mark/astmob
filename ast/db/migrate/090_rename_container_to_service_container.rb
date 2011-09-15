class RenameContainerToServiceContainer < ActiveRecord::Migration
  def self.up
   rename_column :service_checks, :container_id, :service_container_id

  end

  def self.down
    rename_column :service_checks, :service_container_id, :container_id 
  end
end