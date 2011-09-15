class IncreaseServiceCheckerDefinitionSize < ActiveRecord::Migration
  def self.up
    change_column :service_checkers, :definition, :string, :limit => 1024

  end

  def self.down
    raise ActiveRecord::IrreversibleMigration

  end
end
