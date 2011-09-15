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
class NetworksController < ApplicationController
  # GET /networks
  # GET /networks.xml
  def index
    @networks = Network.find(:all)
    
    #raise @networks.inspect
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @networks }
    end
  end

  # GET /networks/1
  # GET /networks/1.xml
  def show
    @network = Network.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @network }
    end
  end

  # GET /networks/new
  # GET /networks/new.xml
  def new
    @network = Network.new
    @network.asset = Asset.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @network }
    end
  end

  # GET /networks/1/edit
  def edit
    @network = Network.find(params[:id])
  end

  # POST /networks
  # POST /networks.xml
  def create
    @network = Network.new(params[:network])

    @asset = Asset.new(params[:asset])
    @network.asset = @asset
    
    # Transaction block to get asset and specific asset type data saved
    Vip.transaction do
      
      @asset.save!      
      @network.save!

      #raise @network.asset.inspect 
      redirect_to :action => :index
    end

    # Catch the exception and present any other validation error if there's any
    rescue ActiveRecord::RecordInvalid => e
      @asset.valid?
      render :action => "new"    
  end

  # PUT /networks/1
  # PUT /networks/1.xml
  def update
    @network = Network.find(params[:id])

    # Better way to do update.  Assign the values first, then save them.
    @network.attributes=params[:network]
    @network.asset.attributes=params[:asset]
    
    respond_to do |format|
      if @network.save && @network.asset.save
        flash[:notice] = 'Network was successfully updated.'
        format.html { render :action => "edit" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @network.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /networks/1
  # DELETE /networks/1.xml
  def destroy
    @network = Network.find(params[:id])
    @network.destroy

    respond_to do |format|
      format.html { redirect_to(networks_url) }
      format.xml  { head :ok }
    end
  end
end
