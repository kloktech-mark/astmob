class RenameTypeCtype < ActiveRecord::Migration
  def self.up
    rename_column :cpu_models, :type, :ctype
  end

  def self.down
    rename_column :cpu_models, :ctype, :type
  end
end
