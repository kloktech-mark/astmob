class RenameTypeToMtype < ActiveRecord::Migration
  def self.up
    # Because type is actually a key word in rail
    rename_column :memory_models, :type, :mtype
  end

  def self.down
    rename_column :memory_models, :mtype, :type
  end
end
