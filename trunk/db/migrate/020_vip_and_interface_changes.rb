class VipAndInterfaceChanges < ActiveRecord::Migration
  def self.up
    add_column :vips, :proto, :string
    add_column :vips, :flag, :string
    
    add_column :interfaces, :mac, :string
  end

  def self.down
    remove_column :interfaces, :mac
    remove_column :vips, :flag
    remove_column :vips, :proto
  end
end
