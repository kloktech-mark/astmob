class AddSlotToMemoryDetails < ActiveRecord::Migration
  def self.up
      add_column :memory_details, :slot, :integer 
  end

  def self.down
      remove_column :memory_details, :slot
  end
end
