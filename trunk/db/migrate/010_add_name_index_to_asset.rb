class AddNameIndexToAsset < ActiveRecord::Migration
  def self.up
    add_index :assets, :name
  end

  def self.down
    remove_index :assets, :name
  end
end
