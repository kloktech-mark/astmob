class CreateServerModels < ActiveRecord::Migration
  def self.up
    create_table :server_models do |t|
      t.string :manufacture
      t.string :model

      t.timestamps
    end
  end

  def self.down
    drop_table :server_models
  end
end
