class AddLoadOidAndSnmpCommToPduModel < ActiveRecord::Migration
  def self.up
    add_column :pdu_models, :oid_load, :string
    add_column :pdu_models, :snmp_read, :string
  end

  def self.down
    remove_column :pdu_models, :oid_load
    remove_column :pdu_models, :snmp_read
    
  end
end
