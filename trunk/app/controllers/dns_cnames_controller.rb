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
class DnsCnamesController < ApplicationController
  # GET /dns_cnames
  # GET /dns_cnames.xml
  def index
    @dns_cnames = DnsCname.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dns_cnames }
    end
  end

  # GET /dns_cnames/1
  # GET /dns_cnames/1.xml
  def show
    @dns_cname = DnsCname.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dns_cname }
    end
  end

  # GET /dns_cnames/new
  # GET /dns_cnames/new.xml
  def new
    @dns_cname = DnsCname.new
    @dns_cname.asset = Asset.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dns_cname }
    end
  end

  # GET /dns_cnames/1/edit
  def edit
    @dns_cname = DnsCname.find(params[:id])
  end

  # POST /dns_cnames
  # POST /dns_cnames.xml
  def create
    @dns_cname = DnsCname.new(params[:dns_cname])
    @dns_cname.asset = Asset.new(params[:asset])
    
    respond_to do |format|
      if @dns_cname.save
        flash[:notice] = 'DnsCname was successfully created.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dns_cname, :status => :created, :location => @dns_cname }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dns_cname.errors, :status => :unprocessable_entity }
      end 
    end
  end

  # PUT /dns_cnames/1
  # PUT /dns_cnames/1.xml
  def update
    @dns_cname = DnsCname.find(params[:id])
    
    respond_to do |format|
      if @dns_cname.update_attributes(params[:dns_cname]) && @dns_cname.asset.update_attributes(params[:asset]) 
        flash[:notice] = 'DnsCname was successfully updated.'
        format.html { render :action => "edit" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dns_cname.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dns_cnames/1
  # DELETE /dns_cnames/1.xml
  def destroy
    @dns_cname = DnsCname.find(params[:id])
    @dns_cname.destroy

    respond_to do |format|
      format.html { redirect_to(dns_cnames_url) }
      format.xml  { head :ok }
    end
  end
  
  def create_cname_detail
    @dns_cname = DnsCname.find(params[:id])

    for asset_id in params[:cname_assets][:asset_id]
      #@dns_cname.dns_cname_details << DnsCnameDetail.create(:asset_id => asset_id)
      d = DnsCnameDetail.create(:asset_id => asset_id, :dns_cname_id => @dns_cname.id)
      d.save!
    end
    
    
    # Look up again to make sure we got it.
    @dns_cname = DnsCname.find(params[:id])

    
    render(:partial => "mini_cname_detail",:object => @dns_cname) 

  end

  def destroy_cname_detail
    dns_cname_detail = DnsCnameDetail.find(params[:id])
    @dns_cname = dns_cname_detail.dns_cname
    
    dns_cname_detail.destroy
    render(:partial => "mini_cname_detail",:object => @dns_cname) 
  end  
  
  # Supply hostname, return with cnames pointing to host
  def check_cnames
    @asset = Asset.find_by_name(params[:host])
    #raise @asset.dns_cnames.collect{|a| a.name}
    render(:partial => "check_cnames",:object => @asset)    
    
  end
end
