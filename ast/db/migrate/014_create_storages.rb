class CreateStorages < ActiveRecord::Migration
  def self.up
    create_table :storages do |t|
      t.string :raid_type
      t.string :controller
      t.string :enclosure
      t.string :os

      t.timestamps
    end
  end

  def self.down
    drop_table :storages
  end
end
