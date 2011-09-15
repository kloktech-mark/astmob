class CreateVlanDetails < ActiveRecord::Migration
  def self.up
    create_table :vlan_details do |t|
      t.integer :colo_id
      t.integer :vlan_id
      t.string :subnet

      t.timestamps
    end
  end

  def self.down
    drop_table :vlan_details
  end
end
