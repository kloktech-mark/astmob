class CreateNagiosContactGroupServiceEscalationDetails < ActiveRecord::Migration
  def self.up
    create_table :nagios_contact_group_service_escalation_details do |t|
      t.integer :nagios_contact_group_id
      t.integer :nagios_service_escalation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :nagios_contact_group_service_escalation_details
  end
end
