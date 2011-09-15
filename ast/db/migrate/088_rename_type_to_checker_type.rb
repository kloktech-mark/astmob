class RenameTypeToCheckerType < ActiveRecord::Migration
  def self.up
   rename_column :service_checkers, :type, :checker_type

  end

  def self.down
    rename_column :service_checkers, :checker_type, :type 
  end
end
