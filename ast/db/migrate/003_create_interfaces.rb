class CreateInterfaces < ActiveRecord::Migration
  def self.up
    create_table :interfaces do |t|
      t.string :name
      t.boolean :primary
      t.text :description
      t.string :ip_address
      t.integer :asset_id

      t.timestamps
    end
  end

  def self.down
    drop_table :interfaces
  end
end
