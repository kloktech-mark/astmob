class AddDescriptionToNagiosServices < ActiveRecord::Migration
  def self.up
    add_column :nagios_services, :description, :text
  end

  def self.down
    remove_column :nagios_services, :description
  end
end
