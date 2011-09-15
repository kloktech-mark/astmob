class ModIpColumn < ActiveRecord::Migration
  def self.up
      change_column :interfaces,  :ip, :bigint, :unsigned => true
  end

  def self.down
      change_column :interfaces,  :ip, :integer
  end
end
