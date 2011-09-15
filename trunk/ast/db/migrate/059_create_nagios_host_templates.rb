class CreateNagiosHostTemplates < ActiveRecord::Migration
  def self.up
    create_table :nagios_host_templates do |t|
      t.string :name

      t.timestamps
    end
    
    add_column :nagios_host_groups, :nagios_host_template_id, :integer 

    
  end

  def self.down
    drop_table :nagios_host_templates
    remove_column :nagios_host_groups, :nagios_host_template_id
  end
end
