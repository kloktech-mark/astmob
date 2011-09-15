class RenameMemoryDetailToModel < ActiveRecord::Migration
  def self.up
    rename_table :memory_details, :memory_models
  end

  def self.down
    rename_table :memory_models, :memory_details
  end
end
