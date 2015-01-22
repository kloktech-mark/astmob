class Subnet < ActiveRecord::Base

  acts_as_nested_set

  acts_as_solr :additional_fields => [:colo_name, :vlan_name]

  validates_uniqueness_of :network

  def cidr
    NetAddr::CIDR.create(self.network)
  end

  def vlan_detail
    if ( s = VlanDetail.find_by_subnet_v6(self.network) ) 
      return s
    elsif (t= VlanDetail.find_by_subnet(self.network))
      return t
    end
  end

  def colo_name
    if !self.vlan_detail.nil?
      self.vlan_detail.colo.name
    end
  end

  def vlan_name
    if !self.vlan_detail.nil?
      self.vlan_detail.vlan.name
    end
  end
end
