class CreateDnsMxRecords < ActiveRecord::Migration
  def self.up
    create_table :dns_mx_records do |t|
      t.string :name
      t.integer :dns_zone_id
      t.integer :priority

      t.timestamps
    end
  end

  def self.down
    drop_table :dns_mx_records
  end
end
