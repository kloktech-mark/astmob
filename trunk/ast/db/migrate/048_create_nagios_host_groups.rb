class CreateNagiosHostGroups < ActiveRecord::Migration
  def self.up
    create_table :nagios_host_groups do |t|
      t.string :name
      t.text :hosts

      t.timestamps
    end
  end

  def self.down
    drop_table :nagios_host_groups
  end
end
