class AddUnitToStorage < ActiveRecord::Migration
  def self.up
    add_column :storages, :unit, :integer
  end

  def self.down
    remove_column :storages, :unit
  end

end
