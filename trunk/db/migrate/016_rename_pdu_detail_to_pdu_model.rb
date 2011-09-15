class RenamePduDetailToPduModel < ActiveRecord::Migration
  def self.up
    rename_table :pdu_details, :pdu_models
    rename_column :pdus, :pdu_detail_id, :pdu_model_id   
    
  end

  def self.down
    rename_table :pdu_models, :pdu_details
    rename_column :pdus, :pdu_model_id, :pdu_tail_id    
  end
end
