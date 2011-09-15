class RenameDisksToDiskDetails < ActiveRecord::Migration
  def self.up
    rename_table :disks, :disk_models
    rename_column :disk_details, :disk_id, :disk_model_id
  end

  def self.down
    rename_table :disk_models, :disks
    rename_column :disk_details, :disk_model_id, :disk_id
  end
end
