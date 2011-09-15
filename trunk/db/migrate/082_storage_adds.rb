class StorageAdds < ActiveRecord::Migration
  def self.up
    add_column :disk_models, :drivetype, :string
    add_column :disk_details, :scsiid, :string
  end

  def self.down
    remove_column :disk_models, :drivetype
    remove_column :disk_details, :scsiid
  end
end
