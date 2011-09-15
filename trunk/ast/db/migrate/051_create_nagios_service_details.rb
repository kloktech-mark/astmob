class CreateNagiosServiceDetails < ActiveRecord::Migration
  def self.up
    create_table :nagios_service_details do |t|
      t.integer :nagios_host_group_id
      t.integer :nagios_service_id

      t.timestamps
    end
  end

  def self.down
    drop_table :nagios_service_details
  end
end
