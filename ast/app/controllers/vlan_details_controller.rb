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

    @utils = Hash.new()

    @vlan_details.each{|v| 
      total = 0
      # subnet takes comma separated values
      v.subnet.split(',').each{|s|
        cidr = NetAddr::CIDR.create(s)
        total = total + cidr.size()
      }
      @utils[v.id] = Hash.new()
      @utils[v.id]['total'] = total
      @utils[v.id]['used'] = v.interfaces.length
      @utils[v.id]['prct_used'] = (v.interfaces.length.to_f / total.to_f * 100).round(2) rescue nil
    }

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

  # Show asset with IP under that vlan
  def vlan_hosts
    @vlan_detail = VlanDetail.find(params[:id])
    @assets = @vlan_detail.assets.sort{|a,b| a.name <=> b.name}
    @assets = @assets.uniq{|x| x.name}
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assets }
    end
  end
end
