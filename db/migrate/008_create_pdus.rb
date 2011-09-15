class CreatePdus < ActiveRecord::Migration
  def self.up
    create_table :pdus do |t|
      t.integer :consumption
      t.string :ip
      t.integer :pdu_detail_id

      t.timestamps
    end
  end

  def self.down
    drop_table :pdus
  end
end
