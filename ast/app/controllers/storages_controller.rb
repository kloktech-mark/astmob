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
class StoragesController < ApplicationController
  # GET /storages
  # GET /storages.xml
  def index
    @storages = Storage.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @storages }
    end
  end

  # GET /storages/1
  # GET /storages/1.xml
  def show
    @storage = Storage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @storage }
    end
  end

  # GET /storages/new
  # GET /storages/new.xml
  def new
    @storage = Storage.new
    @storage.asset = Asset.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @storage }
    end
  end

  # GET /storages/1/edit
  def edit
    @storage = Storage.find(params[:id])
  end

  # POST /storages
  # POST /storages.xml
  def create
    @storage = Storage.new(params[:storage])
    @storage.asset = Asset.new(params[:asset])
    @storage.asset.disk_details << DiskDetail.new(params[:disk_detail])
    
    respond_to do |format|
      if @storage.save
        flash[:notice] = 'Storage was successfully created.'
        format.html { redirect_to(@storage) }
        format.xml  { render :xml => @storage, :status => :created, :location => @storage }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @storage.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /storages/1
  # PUT /storages/1.xml
  def update
    @storage = Storage.find(params[:id])

    # Transaction only if both succeed would the database call be committed.
    Pdu.transaction do

      # Exception catch block, but let it run through all the transaction until the last one.
      begin
        @storage.update_attributes!(params[:storage])
      rescue ActiveRecord::RecordInvalid => e
        # Run the second update anyway and let it catch all the incorrect entries.
        @storage.asset.update_attributes!(params[:asset])
        # It would be rolled back anyway since we raise the exception again ourself.
        raise
      end
      # if storage updates fine, we'll update asset as well.  If it fails, the later rescue to catch it.      
      @storage.asset.update_attributes!(params[:asset])

    end

    # If everything passed in transaction, redirect.
    flash[:notice] = 'Pdu was successfully updated.'
    respond_to do |format|
      format.html { redirect_to(storages_url) }
      format.xml  { head :ok }
    end      

    # Catch the exception AND redraw the form for input
    rescue ActiveRecord::RecordInvalid => e
      @asset = @storage.asset
      render :action => "edit"
  end

  # DELETE /storages/1
  # DELETE /storages/1.xml
  def destroy
    @storage = Storage.find(params[:id])
    @storage.destroy

    respond_to do |format|
      format.html { redirect_to(storages_url) }
      format.xml  { head :ok }
    end
  end
end
