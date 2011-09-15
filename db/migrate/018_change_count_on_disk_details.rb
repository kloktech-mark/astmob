class ChangeCountOnDiskDetails < ActiveRecord::Migration
  def self.up
    rename_column :disk_details, :count, :cnt     
  end

  def self.down
    rename_column :disk_details, :cnt, :count     
    
  end
end
