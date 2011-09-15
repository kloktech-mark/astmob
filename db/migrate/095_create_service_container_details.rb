class CreateServiceContainerDetails < ActiveRecord::Migration
  def self.up
    create_table :service_container_details do |t|
      t.integer :nagios_host_group_id
      t.integer :service_container_id

      t.timestamps  
    end    
  end

  def self.down
    drop_table :service_container_details
  end
end