class AddVlanDetailIdToInterface < ActiveRecord::Migration
  def self.up
    add_column :interfaces, :vlan_detail_id, :integer
  end

  def self.down
    remove_column :interfaces, :vlan_detail_id
  end
end
