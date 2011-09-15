class CreateDisks < ActiveRecord::Migration
  def self.up
    create_table :disks do |t|
      t.string :name
      t.string :speed
      t.integer :capacity
      t.string :part_number

      t.timestamps
    end
  end

  def self.down
    drop_table :disks
  end
end
