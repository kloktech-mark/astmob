class RenameVipIdtoVipAssetId < ActiveRecord::Migration
  def self.up
    rename_column :vip_servers, :vip_id, :vip_asset_id
  end

  def self.down
    rename_column :vip_servers, :vip_asset_id, :vip_id
  end
end
