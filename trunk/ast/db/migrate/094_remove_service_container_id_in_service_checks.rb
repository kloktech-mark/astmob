class RemoveServiceContainerIdInServiceChecks < ActiveRecord::Migration
  def self.up
    remove_column :service_checks, :service_container_id
  end

  def self.down
    add_column :service_checks, :service_container_id, :integer
  end
end
