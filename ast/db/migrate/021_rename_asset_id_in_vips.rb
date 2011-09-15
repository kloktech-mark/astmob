class RenameAssetIdInVips < ActiveRecord::Migration
  def self.up
    rename_column :vips, :asset_id, :hoster_id
  end

  def self.down
    rename_column :vips, :hoster_id, :asset_id
  end
end
