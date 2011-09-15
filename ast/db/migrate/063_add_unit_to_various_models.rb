class AddUnitToVariousModels < ActiveRecord::Migration
  def self.up
    add_column :server_models, :unit, :integer
    add_column :network_models, :unit, :integer
    add_column :pdu_models, :unit, :integer
  end

  def self.down
    remove_column :pdu_models, :unit
    remove_column :network_models, :unit
    remove_column :server_models, :unit
  end
end
