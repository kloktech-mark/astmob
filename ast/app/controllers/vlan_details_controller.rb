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
class VlanDetailsController < ApplicationController
  # GET /vlan_details
  # GET /vlan_details.xml
  def index
    @vlan_details = VlanDetail.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vlan_details }
    end
  end

  # GET /vlan_details/1
  # GET /vlan_details/1.xml
  def show
    @vlan_detail = VlanDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vlan_detail }
    end
  end

  # GET /vlan_details/new
  # GET /vlan_details/new.xml
  def new
    @vlan_detail = VlanDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vlan_detail }
    end
  end

  # GET /vlan_details/1/edit
  def edit
    @vlan_detail = VlanDetail.find(params[:id])
  end

  # POST /vlan_details
  # POST /vlan_details.xml
  def create
    @vlan_detail = VlanDetail.new(params[:vlan_detail])

    respond_to do |format|
      if @vlan_detail.save
        flash[:notice] = 'VlanDetail was successfully created.'
        format.html { redirect_to(@vlan_detail) }
        format.xml  { render :xml => @vlan_detail, :status => :created, :location => @vlan_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vlan_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vlan_details/1
  # PUT /vlan_details/1.xml
  def update
    @vlan_detail = VlanDetail.find(params[:id])

    respond_to do |format|
      if @vlan_detail.update_attributes(params[:vlan_detail])
        flash[:notice] = 'VlanDetail was successfully updated.'
        format.html { redirect_to(@vlan_detail) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vlan_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vlan_details/1
  # DELETE /vlan_details/1.xml
  def destroy
    @vlan_detail = VlanDetail.find(params[:id])
    @vlan_detail.destroy

    respond_to do |format|
      format.html { redirect_to(vlan_details_url) }
      format.xml  { head :ok }
    end
  end
end
