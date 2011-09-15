class RenameCpuId < ActiveRecord::Migration
  def self.up
    rename_column :cpu_details, :cpu_id, :cpu_model_id
  end

  def self.down
    rename_column :cpu_details, :cpu_model_id, :cpu_id
  end
end
