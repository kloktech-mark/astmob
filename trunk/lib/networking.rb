# Copyright 2011 Google Inc. All Rights Reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'rubygems'
require 'netaddr'  

class Networking

  
  def self.i_to_ip(integer)
    if integer.nil?
      return
    end
    NetAddr.i_to_ip(integer)
  end
  
  def self.ip_to_i(string)
   # p ' ip_to _i  input param is ' + string
    
    if string.nil?
      return
    end
    ip_array = string.split('/')
    NetAddr.ip_to_i(ip_array[0])
  end     

  # Return a hash of asset => ip
  def self.get_all_ips_in_vlan(colo_id,vlan_id)
    vlan_detail = VlanDetail.find(:all, :conditions => "vlan_id = #{vlan_id} AND colo_id = #{colo_id}")[0]

    list_master = {}

    for subnet in vlan_detail.subnet.split(",")
      # Break it up and build a range
      cidr = NetAddr::CIDR.create(subnet)
  
      # Calculate interger for the first and  last ip in our subnet. 
      ip_first = NetAddr.ip_to_i(cidr.first)
      ip_last = NetAddr.ip_to_i(cidr.last)
      
      # Find interface that fall within the range of our subnet
      interface_matches = Interface.find(:all, :select => "asset_id, ip", 
      :conditions => "ip > #{ip_first} AND ip < #{ip_last}")
      
      # If a server has multiple IP, only the last one will be return in the hash
      list_used = {}
      for interface in interface_matches
        list_used[interface.asset_id] = NetAddr.i_to_ip(interface, ip_addr) 
      end
      list_master += list_used
    end

    return list_master
  end
  
  # Return vlan for an ip address
  def self.get_vlan_for_ip(ip)
    vlan_details = VlanDetail.find(:all)

    # In case IP address has a '/', we only take the first IP.  
    # ocs separate its IP by '/', regular network expression uses it as netmask
    if ( ip =~ /\// )
      ip = ip.split('/')[0]
    end
    
    
    # For each vlan_detail, let's see if matches specify ip
    for vlan_detail in vlan_details
      for subnet in vlan_detail.subnet.split(",")
        vlan_cidr = NetAddr::CIDR::create(subnet)
        if vlan_cidr.contains?(ip)
         return vlan_detail
        end
      end
    end

    return nil
  end
 

  
  # Add drac ip to asset
  # Generate a DRAC IP for new asset if save works successfully.
  # This same piece code should work when host changes colo as well.
  def self.get_drac_ip(asset)

    # Find the drac vlan for asset's colo
    vlan_detail = VlanDetail.find(:first, 
                  :include => :vlan,
                  :conditions => "vlan_details.colo_id = #{asset.colo_id} AND vlans.drac = '1'")


    if ! vlan_detail.nil? 
      get_an_ip(asset,vlan_detail.id)
    else
      return nil
      #flash[:warning] = "No DRAC Vlan setup for asset's colo"  
    end
  end

  
  # Return a free ip to be used for particular vlan
  # Remember, after installing new gem, server has to restart in order to see them
  def self.get_an_ip(asset,vlan_detail,multi_ip=false)  
    
    # Reserved first 30 IP for network devices
    skipping_ip = 30
    
    # Flag to detect if ip already exist in vlan_detail
    ip_already_exist = false
    return_ip = ''
    
    # Find the subnet from vlan_detail
    vlan_detail = VlanDetail.find(vlan_detail)
    

    # Get the list from interface table, if one already exist, don't create new one.
    interface = Interface.find(:first, :conditions => "asset_id = #{asset.id} AND vlan_detail_id = #{vlan_detail.id}")
    
    # If there isn't one belonging to the vlan, destroy the existing ip,
    # then assign a new one.  If there is one, return that ip.
    if ( ! interface.nil? && ! multi_ip )
      #flash[:error] = "Server already belongs to vlan"
      interface.ip
    else
      # Instead of single subnet, we going to support comma separated subnet mask
      for subnet in vlan_detail.subnet.split(",")
        # Break it up and build a range
        cidr = NetAddr::CIDR.create(subnet.chomp)
  
        # list of ALL ips in the subnet
        list_master = NetAddr.range(cidr.nth(skipping_ip),cidr.last)
    
        # Calculate interger for the first and  last ip in our subnet. 
        ip_first = NetAddr.ip_to_i(cidr.first) + skipping_ip
        ip_last = NetAddr.ip_to_i(cidr.last)
        
        # Find interface that fall within the range of our subnet
        interface_matches = Interface.find(:all, :select => "ip", :conditions => "ip > #{ip_first} AND ip < #{ip_last}")
    
        # Build the match list and convert integer back to IP addres
        list_used = []
        for interface in interface_matches
          list_used << NetAddr.i_to_ip(interface.ip) 
        end
        
        # Get the list of ip that's not used.  Master list minus used list
        list_free = list_master - list_used
    
        # Return the first ip from remaining list only 
        # if last digit doesn't end with 0,1,255
        i = 0
        while list_free[i] =~ /\.(0|1|255)$/
          i = i + 1
        end
        ip = list_free[i]
    
        if ( ! ip.nil? )
          asset.interfaces << Interface.new(:ip => ip, :vlan_detail_id => vlan_detail.id)
          return ip
        end
      end
    end
  end  

  # Return a hash of interfaces
  def self.get_interfaces_in_range(address)

    # Break it up and build a range
    cidr = NetAddr::CIDR.create(address)

    # Calculate interger for the first and  last ip in our subnet. 
    ip_first = NetAddr.ip_to_i(cidr.first)
    ip_last = NetAddr.ip_to_i(cidr.last)
    
    # Find interface that fall within the range of our subnet
    interface_matches = Interface.find(:all,  
    :conditions => "ip > #{ip_first} AND ip < #{ip_last}")

    # Return all matched interface in the range
    return interface_matches
    
  end  

  # Find the gateway given a subnet.  Assuming gateway is the first ip.
  def self.gateway(subnets)
    ips = []

    # We have vlan_detail with multiple subnets
    for s in subnets.split(",")
      cidr = NetAddr::CIDR.create(s.chomp)
      # Find the first ip in subnet.
      ips << NetAddr.ip_to_i(cidr.first) + 1
    end

    # Sort them and the first ip is the gateway
    ips = ips.sort{|a,b| a <=> b}
    i_to_ip(ips[0])
  end

  def self.netmask(subnet)
    subnets = subnet.split(",")

    # If there are multiple subnet given, find the supernet that covers it all.  This is for drac
    if subnets.length > 1 
      cidrs = []
      for s in subnets
        cidrs << NetAddr::CIDR.create(s)
      end
      # cidr_summarize builds a tree with parent node that covers all given subnet
      NetAddr.cidr_summarize(cidrs)[0].netmask_ext
    else 
      cidr = NetAddr::CIDR.create(subnet)
      cidr.netmask_ext
    end

  end
end
