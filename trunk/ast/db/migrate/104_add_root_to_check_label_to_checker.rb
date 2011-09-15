class AddRootToCheckLabelToChecker < ActiveRecord::Migration
  def self.up
    add_column :service_checks, :root, :text
    add_column :service_checkers, :label, :text

  end

  def self.down
    remove_column :service_checks, :root
    remove_column :service_checkers, :label
  end
end
