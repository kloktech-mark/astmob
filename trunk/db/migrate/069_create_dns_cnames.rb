class CreateDnsCnames < ActiveRecord::Migration
  def self.up
    create_table :dns_cnames do |t|
      t.timestamps
    end
  end

  def self.down
    drop_table :dns_cnames
  end
end
