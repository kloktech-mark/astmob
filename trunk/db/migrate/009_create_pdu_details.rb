class CreatePduDetails < ActiveRecord::Migration
  def self.up
    create_table :pdu_details do |t|
      t.string :part_number
      t.string :manufacture
      t.integer :receptible
      t.string :voltage
      t.string :ampere
      t.string :wattage

      t.timestamps
    end
  end

  def self.down
    drop_table :pdu_details
  end
end
