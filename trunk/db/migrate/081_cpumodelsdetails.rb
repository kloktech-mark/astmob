class Cpumodelsdetails < ActiveRecord::Migration
  def self.up
    add_column :cpu_details, :num_cores, :integer
    remove_column :cpu_models, :number
  end

  def self.down
    remove_column :cpu_details, :num_cores
    add_column :cpu_models, :number, :integer
  end
end
