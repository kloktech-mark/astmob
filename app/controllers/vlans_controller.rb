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
class VlansController < ApplicationController
  # GET /vlans
  # GET /vlans.xml
  def index
    @vlans = Vlan.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vlans }
    end
  end

  # GET /vlans/1
  # GET /vlans/1.xml
  def show
    @vlan = Vlan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vlan }
    end
  end

  # GET /vlans/new
  # GET /vlans/new.xml
  def new
    @vlan = Vlan.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vlan }
    end
  end

  # GET /vlans/1/edit
  def edit
    @vlan = Vlan.find(params[:id])
  end

  # POST /vlans
  # POST /vlans.xml
  def create
    @vlan = Vlan.new(params[:vlan])

    respond_to do |format|
      if @vlan.save
        flash[:notice] = 'Vlan was successfully created.'
        format.html { redirect_to(@vlan) }
        format.xml  { render :xml => @vlan, :status => :created, :location => @vlan }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vlan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vlans/1
  # PUT /vlans/1.xml
  def update
    @vlan = Vlan.find(params[:id])

    respond_to do |format|
      if @vlan.update_attributes(params[:vlan])
        flash[:notice] = 'Vlan was successfully updated.'
        format.html { redirect_to(@vlan) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vlan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vlans/1
  # DELETE /vlans/1.xml
  def destroy
    @vlan = Vlan.find(params[:id])
    @vlan.destroy

    respond_to do |format|
      format.html { redirect_to(vlans_url) }
      format.xml  { head :ok }
    end
  end
end
