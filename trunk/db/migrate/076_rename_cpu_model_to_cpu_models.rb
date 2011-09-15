class RenameCpuModelToCpuModels < ActiveRecord::Migration
  def self.up
    rename_table :cpu_model, :cpu_models
  end

  def self.down
    rename_table :cpu_models, :cpu_model
  end
end
