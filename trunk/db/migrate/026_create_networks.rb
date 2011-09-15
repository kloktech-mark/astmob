class CreateNetworks < ActiveRecord::Migration
  def self.up
    create_table :networks do |t|
      t.integer :network_model_id

      t.timestamps
    end
  end

  def self.down
    drop_table :networks
  end
end
