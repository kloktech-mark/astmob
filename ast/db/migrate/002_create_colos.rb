class CreateColos < ActiveRecord::Migration
  
  def self.up
    create_table :colos do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :colos
  end
end
