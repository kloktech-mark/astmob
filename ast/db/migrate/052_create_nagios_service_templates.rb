class CreateNagiosServiceTemplates < ActiveRecord::Migration
  def self.up
    create_table :nagios_service_templates do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :nagios_service_templates
  end
end
