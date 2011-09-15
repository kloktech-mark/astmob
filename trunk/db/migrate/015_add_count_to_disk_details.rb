class AddCountToDiskDetails < ActiveRecord::Migration
  def self.up
    add_column :disk_details, :count, :integer
  end

  def self.down
    add_column :disk_details, :count    
  end
end
