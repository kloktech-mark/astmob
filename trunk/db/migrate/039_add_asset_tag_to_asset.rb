class AddAssetTagToAsset < ActiveRecord::Migration
  def self.up
    add_column :assets, :asset_tag, :string
  end

  def self.down
    remove_column :assets, :asset_tag

  end
end
