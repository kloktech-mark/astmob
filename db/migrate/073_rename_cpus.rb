class RenameCpus < ActiveRecord::Migration
  def self.up
    rename_table :cpus, :cpu_models
  end

  def self.down
    rename_table :cpu_models, :cpus
  end
end
