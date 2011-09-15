class CreateNagiosServices < ActiveRecord::Migration
  def self.up
    create_table :nagios_services do |t|
      t.string :name
      t.integer :nagios_service_template_id
      t.string :check_command
      

      t.timestamps
    end
  end

  def self.down
    drop_table :nagios_services
  end
end
