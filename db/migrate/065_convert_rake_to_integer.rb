class ConvertRakeToInteger < ActiveRecord::Migration
  def self.up
    change_column :assets, :rack, :integer
  end

  def self.down
    change_column :assets, :rack, :string
  end
end
