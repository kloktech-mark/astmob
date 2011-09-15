class AddDracIdentifierTo < ActiveRecord::Migration
  def self.up
    add_column :vlan_details, :drac, :boolean, :default => false
  end

  def self.down
    remove_column :vlan_details, :drac
  end
end
