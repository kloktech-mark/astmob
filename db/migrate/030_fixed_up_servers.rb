class FixedUpServers < ActiveRecord::Migration
  def self.up
    
    remove_column :servers, :asset_id
    add_column :servers, :state, :string
    add_column :servers, :server_model_id, :integer
    add_column :servers, :service_tag, :string
    add_column :servers, :bios_version, :string
  end

  def self.down
    add_column :servers, :asset_id, :integer
    drop_column :servers, :state
    drop_column :servers, :server_model_id
    drop_column :servers, :service_tag
    drop_column :servers, :bios_version
  end
end
