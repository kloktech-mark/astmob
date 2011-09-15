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
class PdusController < ApplicationController
  # GET /pdus
  # GET /pdus.xml
  def index
    @pdus = Pdu.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pdus }
    end
  end

  # GET /pdus/1
  # GET /pdus/1.xml
  def show
    @pdu = Pdu.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pdu }
    end
  end

  # GET /pdus/new
  # GET /pdus/new.xml
  def new
    
    # Initialize pdu object
    @pdu = Pdu.new
    
    # Initialize asset object
    @pdu.asset = Asset.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pdu }
    end
  end

  # GET /pdus/1/edit
  def edit
    @pdu = Pdu.find(params[:id])
  end

  # POST /pdus
  # POST /pdus.xml
  def create
    @pdu = Pdu.new(params[:pdu])
    
    # Pick up asset
    @asset = Asset.new(params[:asset])
    
    # Transaction block to get asset and specific asset type data saved
    Pdu.transaction do
      @pdu.asset = @asset
      @pdu.save!      
      @asset.save!
 
      redirect_to :action => :edit, :id => @pdu
    end

    # Catch the exception and present any other validation error if there's any
    rescue ActiveRecord::RecordInvalid => e
      @asset.valid?
      render :action => "new"
  end

  # PUT /pdus/1
  # PUT /pdus/1.xml
  def update
    
    @pdu = Pdu.find(params[:id])

    # Transaction only if both succeed would the database call be committed.
    Pdu.transaction do

      # Exception catch block, but let it run through all the transaction until the last one.
      begin
        @pdu.update_attributes!(params[:pdu])
      rescue ActiveRecord::RecordInvalid => e
        # Run the second update anyway and let it catch all the incorrect entries.
        @pdu.asset.update_attributes!(params[:asset])
        # It would be rolled back anyway since we raise the exception again ourself.
        raise
      end
      # if pdu updates fine, we'll update asset as well.  If it fails, the later rescue to catch it.      
      @pdu.asset.update_attributes!(params[:asset])

    end

    # If everything passed in transaction, redirect.
    flash[:notice] = 'Pdu was successfully updated.'
    respond_to do |format|
      format.html { redirect_to(pdus_url) }
      format.xml  { head :ok }
    end      

    # Catch the exception AND redraw the form for input
    rescue ActiveRecord::RecordInvalid => e
      @asset = @pdu.asset
      render :action => "edit"

  end

  # DELETE /pdus/1
  # DELETE /pdus/1.xml
  def destroy
    @pdu = Pdu.find(params[:id])
    @pdu.asset.destroy
    @pdu.destroy

    respond_to do |format|
      format.html { redirect_to(pdus_url) }
      format.xml  { head :ok }
    end
  end
end
