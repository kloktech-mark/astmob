class CreateNagiosServiceEscalationTemplates < ActiveRecord::Migration
  def self.up
    create_table :nagios_service_escalation_templates do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :nagios_service_escalation_templates
  end
end
