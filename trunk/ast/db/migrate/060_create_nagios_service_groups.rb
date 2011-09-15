class CreateNagiosServiceGroups < ActiveRecord::Migration
  def self.up
    create_table :nagios_service_groups do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :nagios_service_groups
  end
end
