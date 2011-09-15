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
class VipsController < ApplicationController
  # GET /vips
  # GET /vips.xml
  def index
    @vips = Vip.find(:all).sort{|a,b| a.name <=> b.name}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vips }
    end
  end

  # GET /vips/1
  # GET /vips/1.xml
  def show
    @vip = Vip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vip }
    end
  end

  # GET /vips/new
  # GET /vips/new.xml
  def new
    @vip = Vip.new
    @vip.asset = Asset.new
    
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vip }
    end
  end

  # GET /vips/1/edit
  def edit
    @vip = Vip.find(params[:id])

  end

  # POST /vips
  # POST /vips.xml
  def create
    @vip = Vip.new(params[:vip])
    # Pick up asset
    @asset = Asset.new(params[:asset])
    @vip.asset = @asset
    
    # Transaction block to get asset and specific asset type data saved
    Vip.transaction do
      
      @asset.save!      
      @vip.save!

      #raise @vip.asset.inspect 
      redirect_to :action => :index
    end

    # Catch the exception and present any other validation error if there's any
    rescue ActiveRecord::RecordInvalid => e
      @asset.valid?
      render :action => "new"    
  end

  # PUT /vips/1
  # PUT /vips/1.xml
  def update
    @vip = Vip.find(params[:id])

    # Better way to do update.  Assign the values first, then save them.
    @vip.attributes=params[:vip]
    @vip.asset.attributes=params[:asset]
    
    respond_to do |format|
      if @vip.save and @vip.asset.save
        flash[:notice] = 'Vip was successfully updated.'
        format.html { render :action => "edit" }
        #format.html { redirect_to(@vip) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vips/1
  # DELETE /vips/1.xml
  def destroy
    @vip = Vip.find(params[:id])
    @vip.destroy

    respond_to do |format|
      format.html { redirect_to(vips_url) }
      format.xml  { head :ok }
    end
  end
  
  # Link interface id to here
  def link_interface
    
    #raise params.inspect
    @vip = Vip.find(params[:id])
  
    @vip.update_attribute(:interface_id, params[:interfaces][:interface_id])
    
    respond_to do |format|
      format.html { render :partial => 'interfaces/mini_edit_vip', :layout => false, :object => @vip }
      format.xml  { head :ok }
    end
    
  end
end
