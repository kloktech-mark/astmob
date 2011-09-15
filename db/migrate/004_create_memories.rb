class CreateMemories < ActiveRecord::Migration
  def self.up
    create_table :memories do |t|
      t.integer :asset_id
      t.integer :memory_id
      t.timestamps
    end
  end

  def self.down
    drop_table :memories
  end
end
