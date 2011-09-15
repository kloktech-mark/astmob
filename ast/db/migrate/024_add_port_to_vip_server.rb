class AddPortToVipServer < ActiveRecord::Migration
  def self.up
    add_column :vip_servers, :port, :integer
  end

  def self.down
    remove_column :vip_servers, :port
  end
end
