class CreateNetworkModels < ActiveRecord::Migration
  def self.up
    create_table :network_models do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :network_models
  end
end
