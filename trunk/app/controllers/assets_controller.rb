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
class AssetsController < ApplicationController

  # Disable cookie protection for everything except couple function
  protect_from_forgery :only => [:create, :update, :destroy]
                        

  # GET /assets
  # GET /assets.xml
  def index
    @assets = Asset.paginate :page => params[:page], :per_page => 30, :order => 'name'

    #@assets = Asset.find(:all)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assets }
    end
  end

  # GET /assets/1
  # GET /assets/1.xml
  def show
    @asset = Asset.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/new
  # GET /assets/new.xml
  def new
    @asset = Asset.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/1/edit
  def edit
    @asset = Asset.find(params[:id])
  end

  # POST /assets
  # POST /assets.xml
  def create
    @asset = Asset.new(params[:asset])

    respond_to do |format|
      if @asset.save
        flash[:notice] = 'Asset was successfully created.'
        #format.html { redirect_to(@asset) }
        format.html { redirect_to(assets_url) }
        format.xml  { render :xml => @asset, :status => :created, :location => @asset }

      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assets/1
  # PUT /assets/1.xml
  def update
    @asset = Asset.find(params[:id])
    
    respond_to do |format|
      if @asset.update_attributes(params[:asset])
        flash[:notice] = 'Asset was successfully updated.'
        format.html { redirect_to(@asset) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.xml
  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |format|
      format.html { redirect_to(assets_url) }
      format.xml  { head :ok }
    end
  end
  
  # Create dns cname
  def create_dns_cname

    @asset = Asset.find(params[:id])
    
    dns_cname = DnsCnameDetail.new(:name => params[:dns_cname][:name])
    dns_cname.asset = @asset
    
    begin
      dns_cname.save! 
    rescue Exception => exc
      flash[:dns_cname] = "CName create failed with following reason: #{exc.message}"
    end
    
    render(:partial => "assets/dns_cname",:object => @asset)
    
  end
  
  def destroy_dns_cname
    dns_cname = DnsCnameDetail.find(params[:id])
    @asset = dns_cname.asset
    
    # remove dns
    dns_cname.destroy
    
    render(:partial => "assets/dns_cname",:object => @asset)
  end
  
  def dump_data_i
    @assets = Asset.find(:all, :conditions => "resource_type != 'DnsCname' AND resource_type != 'Vip'",
                        :order => "colo_id,name ASC")
    render(:partial => "assets/dump")
  end
  
end
