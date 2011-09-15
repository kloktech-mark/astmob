class AddAutofixToServiceChecks < ActiveRecord::Migration
  def self.up
    add_column :service_checks, :autofix, :text
  end

  def self.down
    remove_column :service_checks, :autofix
  end
end
