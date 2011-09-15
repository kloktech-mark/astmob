class AddDracFlagToVlan < ActiveRecord::Migration
  def self.up
    add_column :vlans, :drac, :boolean, :default => false
    remove_column :vlan_details, :drac
  end

  def self.down
    remove_column :vlans, :drac
    add_column :vlan_details, :drac, :boolean, :default => false

  end
end
