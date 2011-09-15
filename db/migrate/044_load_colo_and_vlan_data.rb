class LoadColoAndVlanData < ActiveRecord::Migration
  def self.up
    
    VlanDetail.destroy_all
    Colo.destroy_all
    Vlan.destroy_all
    
    # Let's load colo
    c = Colo.find_or_create_by_name('rmd')
    c.description = "Raymond St. @ Santa Clara"
    c.save!
    c = Colo.find_or_create_by_name('eq1')
    c.description = "East coast colo @ opsource"
    c.save!
    c = Colo.find_or_create_by_name('sc9')
    c.description = "Savvis colo @ Santa Clara"
    c.save!
    
    # Vlan and Vlan Detail data
    v = Vlan.find_or_create_by_name("Mgr - Network")
    v.vlan_number = 200
    v.save!
    c = Colo.find_by_name('rmd')
    VlanDetail.create!(:colo => c, :vlan => v, :subnet => '10.10.24.0/23')
    c = Colo.find_by_name('sc9')
    VlanDetail.create!(:colo => c, :vlan => v, :subnet => '10.11.24.0/23')

    
    v = Vlan.find_or_create_by_name("App")
    v.vlan_number = 120
    v.save!
    c = Colo.find_by_name('rmd')
    VlanDetail.create!(:colo => c, :vlan => v, :subnet => '10.10.16.0/22')
    c = Colo.find_by_name('sc9')
    VlanDetail.create!(:colo => c, :vlan => v, :subnet => '10.11.16.0/22')
    
    v = Vlan.find_or_create_by_name("DB")
    v.vlan_number = 321
    v.save!
    c = Colo.find_by_name('rmd')
    VlanDetail.create!(:colo => c, :vlan => v, :subnet => '10.10.152.0/22')
    c = Colo.find_by_name('sc9')
    VlanDetail.create!(:colo => c, :vlan => v, :subnet => '10.11.152.0/22')

    v = Vlan.find_or_create_by_name("Mgr - DRAC")
    v.vlan_number = 200
    v.drac = true
    v.save!
    c = Colo.find_by_name('rmd')
    VlanDetail.create!(:colo => c, :vlan => v, :subnet => '216.129.117.0/25')
    c = Colo.find_by_name('sc9')
    VlanDetail.create!(:colo => c, :vlan => v, :subnet => '10.11.26.0/23')
   
  end

  def self.down
  end
end
