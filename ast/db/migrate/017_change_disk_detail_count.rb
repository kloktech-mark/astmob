class ChangeDiskDetailCount < ActiveRecord::Migration
  def self.up
    change_column :disk_details, :count, :integer, :default => 1
  end

  def self.down
     change_column :disk_details, :count, :integer
  end
end
