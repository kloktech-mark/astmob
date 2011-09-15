class CreateCpus < ActiveRecord::Migration
  def self.up
    create_table :cpus do |t|
      t.integer :asset_id
      t.integer :cpu_id
      t.timestamps
#      rename_table :cpus, :cpu_models
    end
  end

  def self.down
    drop_table :cpus
  end
end
