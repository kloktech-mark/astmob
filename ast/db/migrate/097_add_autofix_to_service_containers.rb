class AddAutofixToServiceContainers < ActiveRecord::Migration
  def self.up
    add_column :service_containers, :autofix, :text
  end

  def self.down
    remove_column :service_containers, :autofix
  end
end
