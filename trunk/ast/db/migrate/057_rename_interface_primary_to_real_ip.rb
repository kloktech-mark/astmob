class RenameInterfacePrimaryToRealIp < ActiveRecord::Migration
  def self.up
   rename_column :interfaces, :primary, :real_ip

  end

  def self.down
    rename_column :interfaces, :real_ip, :primary 
  end
end
