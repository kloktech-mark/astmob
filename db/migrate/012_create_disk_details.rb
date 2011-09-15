class CreateDiskDetails < ActiveRecord::Migration
  def self.up
    create_table :disk_details do |t|
      t.integer :asset_id
      t.integer :disk_id

      t.timestamps
    end
  end

  def self.down
    drop_table :disk_details
  end
end
