class AddFieldsToServiceChecks < ActiveRecord::Migration
  def self.up
    add_column :service_checks, :command, :text
  end

  def self.down
    remove_column :service_checks, :command
  end
end
