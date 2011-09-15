class AddFieldsToServiceCheckers < ActiveRecord::Migration
  def self.up
    add_column :service_checkers, :home, :text
    add_column :service_checkers, :command, :text
  end

  def self.down
    remove_column :service_checkers, :home
    remove_column :service_checkers, :command
  end
end
