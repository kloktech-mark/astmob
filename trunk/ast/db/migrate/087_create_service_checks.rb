class CreateServiceChecks < ActiveRecord::Migration
  def self.up
    create_table :service_checks do |t|
      t.string :name
      t.string :description
      t.integer :container_id
      t.integer :parent_id
      t.integer :service_checkers_id
      t.string :definition

      t.timestamps  
    end    
  end

  def self.down
    drop_table :service_checks  
  end
end
