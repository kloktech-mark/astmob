class CreateVips < ActiveRecord::Migration
  def self.up
    create_table :vips do |t|
      t.integer :asset_id
      t.integer :port
      t.timestamps
    end
  end

  def self.down
    drop_table :vips
  end
end
