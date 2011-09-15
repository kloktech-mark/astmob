class IncreaseServiceCheckerDefinitionSizeAgain < ActiveRecord::Migration
  def self.up
    change_column :service_checkers, :definition, :string, :limit => 2048

  end

  def self.down
    raise ActiveRecord::IrreversibleMigration

  end
end
