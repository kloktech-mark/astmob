class CreateNagiosServiceEscalations < ActiveRecord::Migration
  def self.up
    create_table :nagios_service_escalations do |t|
      t.integer :nagios_service_detail_id
      t.integer :nagios_service_escalation_template_id

      t.timestamps
    end
  end

  def self.down
    drop_table :nagios_service_escalations
  end
end
