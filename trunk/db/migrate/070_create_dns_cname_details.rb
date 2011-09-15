class CreateDnsCnameDetails < ActiveRecord::Migration
  def self.up
    create_table :dns_cname_details do |t|
      t.integer :dns_cname_id
      t.integer :asset_id
      t.timestamps
    end
  end

  def self.down
    drop_table :dns_cname_details
  end
end
