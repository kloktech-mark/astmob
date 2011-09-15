class CreateCpuDetails < ActiveRecord::Migration
  def self.up
    create_table :cpu_details do |t|
      t.string :type
      t.string :speed
      t.integer :number
      t.timestamps
    end
  end

  def self.down
    drop_table :cpu_details
  end
end
