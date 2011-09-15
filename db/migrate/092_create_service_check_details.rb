class CreateServiceCheckDetails < ActiveRecord::Migration
  def self.up
    create_table :service_check_details do |t|
      t.integer :container_id
      t.integer :service_check_id

      t.timestamps  
    end    
  end

  def self.down
    drop_table :service_check_details
  end
end