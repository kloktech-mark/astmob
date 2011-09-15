class ChangeIpToInteger < ActiveRecord::Migration
  def self.up
    change_column :interfaces, :ip, :integer
  end

  def self.down
    change_column :interfaces, :ip, :string
  end
end
