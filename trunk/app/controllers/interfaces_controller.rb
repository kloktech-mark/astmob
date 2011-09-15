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

  # Delete posted detail
  def mark_real
    @interface = Interface.find(params[:id])
    @asset = @interface.asset
    #raise @disk_detail.asset.inspect
    
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
    #raise @disk_detail.asset.inspect
    
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
    
    # Do the conversion of ip to integer
    #params[:interface][:ip] = Interface.ip_to_i(params[:interface][:ip])

    # Add it to memory
    #@asset.interfaces << Interface.new(params[:interface])
    @interface = Interface.new(params[:interface])
    @interface.asset = @asset
  
    
    begin
      @interface.save! 
    rescue Exception => exc
      flash[:interface] = "Interface create failed with following reason: #{exc.message}"
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
      if !interface.drac_ip? && interface.vlan_detail != vlan_detail
        interface.destroy
      end
    end

    Networking.get_an_ip(@asset,params[:vlan_detail][:vlan_detail_id])
    
    # Look for asset again so we can see the change reflect right away
    @asset = Asset.find(params[:id])

    flash[:interface] = 'Asset successfully provisioned to new vlan.'

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
    for interface in @asset.interfaces
      if !interface.drac_ip? && interface.vlan_detail != vlan_detail
        interface.destroy
      end
    end

    # Add more IP without care if an IP is already assigned.
    int = Networking.get_an_ip(@asset,vlan_detail.id,true)
    
    # Look for asset again so we can see the change reflect right away
    @asset = Asset.find(params[:id])

    flash[:interface] = '#{int.ip_to_string} added.'

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @asset}
      format.xml  { head :ok }
    end    
  end  
  
end
