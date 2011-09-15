class CreateServiceCheckers < ActiveRecord::Migration
  def self.up
    create_table :service_checkers do |t|
      t.string :name
      t.string :description
      t.integer :type
      t.integer :strict
      t.string :definition

      t.timestamps  
    end
  end

  def self.down
    drop_table :service_checkers    
  end
end
