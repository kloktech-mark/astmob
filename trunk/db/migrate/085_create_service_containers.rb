class CreateServiceContainers < ActiveRecord::Migration
  def self.up
    create_table :service_containers do |t|
      t.string :name
      t.string :description
      t.integer :frequency

      t.timestamps  
    end
  end

  def self.down
    drop_table :service_containers    
  end
end
