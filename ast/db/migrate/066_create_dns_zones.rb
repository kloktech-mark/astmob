class CreateDnsZones < ActiveRecord::Migration
  def self.up
    create_table :dns_zones do |t|
      t.string :name
      t.string :soa
      t.string :a
      t.integer :inherit
      t.integer :ttl
      t.integer :refresh
      t.integer :retry
      t.integer :expire
      t.integer :minimum

      t.timestamps
    end
  end

  def self.down
    drop_table :dns_zones
  end
end
