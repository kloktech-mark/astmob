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
class VipServersController < ApplicationController
  # Ajax only call
  
  # Delete posted detail
  def destroy
    @d = VipServer.find(params[:id])
    @asset = Asset.find(@d.vip_asset_id)
    
    # Kill the row
    @d.destroy
    
    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @asset }
      format.xml  { head :ok }
    end    
    
  end
  
  def create

    # Find the asset
    @asset = Asset.find(params[:id])
    #raise params[:vip_server][:asset_id].inspect
    
    #raise VipServer.new(params[:vip_server]).inspect
    
    # Loop through asset_id in vip_server, and add each item
    for asset in params[:vip_server][:asset_id]
      @asset.vip_servers << VipServer.new(:asset_id => asset, :port => params[:vip_server][:port]) 
    end

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @asset }
      format.xml  { head :ok }
    end    

  end
  
end
