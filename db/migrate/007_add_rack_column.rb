class AddRackColumn < ActiveRecord::Migration
  def self.up
    add_column :assets, :rack, :string
  end

  def self.down
    remove_column :assets, :rack
    
  end
end
