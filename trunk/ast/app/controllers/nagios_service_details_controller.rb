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
class NagiosServiceDetailsController < ApplicationController
  # GET /nagios_service_details
  # GET /nagios_service_details.xml
  def index
    @nagios_service_details = NagiosServiceDetail.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nagios_service_details }
    end
  end

  # GET /nagios_service_details/1
  # GET /nagios_service_details/1.xml
  def show
    @nagios_service_detail = NagiosServiceDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nagios_service_detail }
    end
  end

  # GET /nagios_service_details/new
  # GET /nagios_service_details/new.xml
  def new
    @nagios_service_detail = NagiosServiceDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nagios_service_detail }
    end
  end

  # GET /nagios_service_details/1/edit
  def edit
    @nagios_service_detail = NagiosServiceDetail.find(params[:id])
  end

  # POST /nagios_service_details
  # POST /nagios_service_details.xml
  def create
    @nagios_service_detail = NagiosServiceDetail.new(params[:nagios_service_detail])

    respond_to do |format|
      if @nagios_service_detail.save
        flash[:notice] = 'NagiosServiceDetail was successfully created.'
        format.html { redirect_to(@nagios_service_detail) }
        format.xml  { render :xml => @nagios_service_detail, :status => :created, :location => @nagios_service_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nagios_service_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nagios_service_details/1
  # PUT /nagios_service_details/1.xml
  def update
    @nagios_service_detail = NagiosServiceDetail.find(params[:id])

    respond_to do |format|
      if @nagios_service_detail.update_attributes(params[:nagios_service_detail])
        flash[:notice] = 'NagiosServiceDetail was successfully updated.'
        format.html { redirect_to(@nagios_service_detail) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nagios_service_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nagios_service_details/1
  # DELETE /nagios_service_details/1.xml
  def destroy
    @nagios_service_detail = NagiosServiceDetail.find(params[:id])
    @nagios_service_detail.destroy

    respond_to do |format|
      format.html { redirect_to(nagios_service_details_url) }
      format.xml  { head :ok }
    end
  end
end
