class SwitchCpuModelWithDetails < ActiveRecord::Migration
  def self.up
  rename_table :cpu_details, :cpu_tmp
  rename_table :cpu_models, :cpu_details
  rename_table :cpu_tmp, :cpu_models
  end

  def self.down
  rename_table :cpu_models, :cpu_tmp
  rename_table :cpu_details, :cpu_models
  rename_table :cpu_tmp, :cpu_details
  end
end
