class AddAddionalVlanAndDetail < ActiveRecord::Migration
  def self.up
    # Vlan and Vlan Detail data
    v = Vlan.find_or_create_by_name("Public")
    v.vlan_number = 100
    v.save!
    c = Colo.find_by_name('rmd')
    VlanDetail.create!(:colo => c, :vlan => v, :subnet => '216.129.122.0/25')
    
    c = Colo.find_by_name('sc9')
    VlanDetail.create!(:colo => c, :vlan => v, :subnet => '165.193.245.0/24')
  end

  def self.down
  end
end
