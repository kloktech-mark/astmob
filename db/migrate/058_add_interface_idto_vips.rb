class AddInterfaceIdtoVips < ActiveRecord::Migration
  def self.up
    add_column :vips, :interface_id, :integer 
  end

  def self.down
    remove_column :vips, :interface_id
  end
end
