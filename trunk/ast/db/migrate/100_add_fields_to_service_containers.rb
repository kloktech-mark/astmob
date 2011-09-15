class AddFieldsToServiceContainers < ActiveRecord::Migration
  def self.up
    add_column :service_containers, :check_command, :text
    add_column :service_containers, :nagios_service_template_id, :text
  end

  def self.down
    remove_column :service_containers, :check_command
    remove_column :service_containers, :nagios_service_template_id
  end
end
