class CreateDnsNsRecords < ActiveRecord::Migration
  def self.up
    create_table :dns_ns_records do |t|
      t.string :name
      t.integer :dns_zone_id
      t.integer :ttl

      t.timestamps
    end
  end

  def self.down
    drop_table :dns_ns_records
  end
end
