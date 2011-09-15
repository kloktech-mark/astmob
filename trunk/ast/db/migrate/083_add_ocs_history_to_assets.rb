class AddOcsHistoryToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :ocs_history, :text
  end

  def self.down
    remove_column :assets, :ocs_history
  end
end
