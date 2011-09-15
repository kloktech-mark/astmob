class CreateVipServers < ActiveRecord::Migration
  def self.up
    create_table :vip_servers do |t|
      t.integer :vip_id
      t.integer :asset_id

      t.timestamps
    end
  end

  def self.down
    drop_table :vip_servers
  end
end
