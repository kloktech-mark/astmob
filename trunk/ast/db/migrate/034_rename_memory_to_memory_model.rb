class RenameMemoryToMemoryModel < ActiveRecord::Migration
  def self.up
    rename_column :memories, :memory_id, :memory_model_id
    rename_table :memories, :memory_details
  end

  def self.down
    rename_table :memory_details, :memories
    rename_column :memories, :memory_model_id, :memory_id
  end
end
