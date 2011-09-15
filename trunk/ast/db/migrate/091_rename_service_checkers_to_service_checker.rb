class RenameServiceCheckersToServiceChecker < ActiveRecord::Migration
  def self.up
   rename_column :service_checks, :service_checkers_id, :service_checker_id

  end

  def self.down
    rename_column :service_checks, :service_checker_id, :service_checkers_id 
  end
end