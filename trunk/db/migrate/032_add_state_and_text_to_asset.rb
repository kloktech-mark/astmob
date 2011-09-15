class AddStateAndTextToAsset < ActiveRecord::Migration
  def self.up
    add_column :assets, :state_id, :integer
    add_column :assets, :note, :text
  end

  def self.down
    remove_column :assets, :state_id
    remove_column :assets, :note
   
  end
end
