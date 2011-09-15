class CreateNagiosContactGroups < ActiveRecord::Migration
  def self.up
    create_table :nagios_contact_groups do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :nagios_contact_groups
  end
end
