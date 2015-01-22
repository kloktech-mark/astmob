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
class InterfacesController < ApplicationController

  in_place_edit_for :interface, :name
  in_place_edit_for :interface, :mac

  # Delete posted detail
  def mark_real
    @interface = Interface.find(params[:id])
    @asset = @interface.asset
    
    # Unmark all interface of asset's non drac interface
    for i in @asset.non_drac_interfaces
      i.update_attribute(:real_ip, false)
    end
    
    
    @interface.update_attribute(:real_ip, true)
    
    @interface = nil
    
    @asset = Interface.find(params[:id]).asset

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @asset }
      format.xml  { head :ok }
    end    
    
  end
  
  # Delete posted detail
  def destroy
    @interface = Interface.find(params[:id])
    @asset = @interface.asset
    
    # Kill the row
    @interface.destroy
    @interface = nil
    
    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @asset }
      format.xml  { head :ok }
    end    
    
  end
  
  def create
    
    # Find the asset
    @asset = Asset.find(params[:id])
    
    @interface = Interface.new(params[:interface])
    @interface.asset = @asset
  
    begin
      @interface.save! 
    rescue Exception => exc
      flash[:interface] = "Interface creation failed: " + exc.message
    end
    
    # Remove the object so template wont use its value
    @interface = nil
   
    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @asset}
      format.xml  { head :ok }
    end    
  end
  
  def provision_vlan
    # Find the asset
    @asset = Asset.find(params[:id])
    
    vlan_detail = VlanDetail.find(params[:vlan_detail][:vlan_detail_id])

    # Go through asset's interfaces, if it's not drac and not the same as the one user just select,
    # Delete it.
    for interface in @asset.interfaces
      if !interface.drac_ip? && interface.vlan_detail != vlan_detail && vlan_detail.colo.backbone == false
        interface.destroy
      end
    end

    Networking.get_an_ip(@asset,vlan_detail)
    
    # Look for asset again so we can see the change reflect right away
    @asset = Asset.find(params[:id])

    if vlan_detail.colo.backbone == true
      flash[:interface] = "Added backbone IP from #{vlan_detail.colo.name} - #{vlan_detail.vlan.name}" 
    else
      flash[:interface] = 'Asset successfully provisioned to new vlan.'
    end

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @asset}
      format.xml  { head :ok }
    end    
  end

  def add_v6
    # Find the asset
    @asset = Asset.find(params[:id])
    
    # Make sure ipv6 doesn't exist
    if !@asset.primary_interface_has_v6
      vlan_detail = @asset.primary_interface.vlan_detail 
      rs = Networking.get_an_ip(@asset,vlan_detail, false)
    end

    # Look for asset again so we can see the change reflect right away
    @asset = Asset.find(params[:id])

    if !@asset.primary_interface_has_v6
      flash[:interface] = 'Problem adding v6 IP.' + rs.inspect
    end

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @asset}
      format.xml  { head :ok }
    end    
  end  

  def add_drac
    # Find the asset
    @asset = Asset.find(params[:id])
    
    # Make sure drac doesn't exist
    if @asset.drac_interface.nil?
      
      Networking.get_drac_ip(@asset)
    end

    # Look for asset again so we can see the change reflect right away
    @asset = Asset.find(params[:id])

    if @asset.drac_interface.nil?
      flash[:interface] = 'Problem adding DRAC ip'
    else 
      flash[:interface] = 'Drac Added.'
    end

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @asset}
      format.xml  { head :ok }
    end    
  end  

  def multi_ip
    # Find the asset
    @asset = Asset.find(params[:id])
    
    vlan_detail = VlanDetail.find(params[:multi_ip][:vlan_detail_id])

    # Go through asset's interfaces, if it's not drac and not the same as the one user just select,
    # Delete it.
#    for interface in @asset.interfaces
#      if !interface.drac_ip? && interface.vlan_detail != vlan_detail
#        interface.destroy
#      end
#    end

    # Add more IP without caring if an IP is already assigned.
    int = Networking.get_an_ip(@asset,vlan_detail,true)
    
    # Look for asset again so we can see the change reflect right away
    @asset = Asset.find(params[:id])

    flash[:interface] = int.inspect + ' added.'

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @asset}
      format.xml  { head :ok }
    end    
  end  
  
  def network_assets
    networks = Network.all

    @o = ''
    networks.each do |network|
      if ! network.asset.nil?
        network.asset.interfaces.each do |int|
          @o += sprintf "%s,%s,%s,%d\n", int.ip_to_string, int.name, int.asset.name, int.real_ip ? "1":"0" rescue nil
        end
      else
        raise network.inspect
      end
    end
    render :plain => @o
  end

end
