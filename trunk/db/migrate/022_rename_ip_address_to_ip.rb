class RenameIpAddressToIp < ActiveRecord::Migration
  def self.up
    rename_column :interfaces, :ip_address, :ip
  end

  def self.down
    rename_column :interfaces, :ip, :ip_address
  end
end
