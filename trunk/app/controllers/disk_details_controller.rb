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
class DiskDetailsController < ApplicationController
  # Ajax only call
  
  # Delete posted detail
  def destroy
    @disk_detail = DiskDetail.find(params[:id])
    @asset = @disk_detail.asset
    #raise @disk_detail.asset.inspect
    
    # Kill the row
    @disk_detail.destroy
    
    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @asset }
      format.xml  { head :ok }
    end    
    
  end
  
  def create

    # Find the asset
    @asset = Asset.find(params[:id])
    # Add it to memory
    @asset.disk_details << DiskDetail.new(params[:disk_detail])

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @asset }
      format.xml  { head :ok }
    end    


  end
  
end
