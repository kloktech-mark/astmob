class CreateMemoryDetails < ActiveRecord::Migration
  def self.up
    create_table :memory_details do |t|
      t.string :speed
      t.string :type
      t.integer :capacity

      t.timestamps
    end
  end

  def self.down
    drop_table :memory_details
  end
end
