class AddRowAndPosToAsset < ActiveRecord::Migration
  def self.up
    add_column :assets, :row, :string
    add_column :assets, :pos, :integer
  end

  def self.down
    remove_column :assets, :pos
    remove_column :assets, :row
  end
end
