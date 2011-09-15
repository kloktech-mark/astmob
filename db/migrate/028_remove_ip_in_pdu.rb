class RemoveIpInPdu < ActiveRecord::Migration
  def self.up
    remove_column :pdus, :ip
  end

  def self.down
    add_column :pdus, :ip, :string
  end
end
