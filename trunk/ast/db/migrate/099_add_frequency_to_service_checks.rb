class AddFrequencyToServiceChecks < ActiveRecord::Migration
  def self.up
    add_column :service_checks, :frequency, :integer
  end

  def self.down
    remove_column :service_checks, :frequency
  end
end
