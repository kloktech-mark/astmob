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
class ServiceCheckDetailsController < ApplicationController
  # GET /service_check_details
  # GET /service_check_details.xml
  def index
    @service_check_details = ServiceCheckDetail.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @service_check_details }
    end
  end

  # GET /service_check_details/1
  # GET /service_check_details/1.xml
  def show
    @service_check_detail = ServiceCheckDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service_check_detail }
    end
  end

  # GET /service_check_details/new
  # GET /service_check_details/new.xml
  def new
    @service_check_detail = ServiceCheckDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service_check_detail }
    end
  end

  # GET /service_check_details/1/edit
  def edit
    @service_check_detail = ServiceCheckDetail.find(params[:id])
  end

  # POST /service_check_details
  # POST /service_check_details.xml
  def create
    @service_check_detail = ServiceCheckDetail.new(params[:service_check_detail])

    respond_to do |format|
      if @service_check_detail.save
        flash[:notice] = 'ServiceCheckDetail was successfully created.'
        format.html { redirect_to(@service_check_detail) }
        format.xml  { render :xml => @service_check_detail, :status => :created, :location => @service_check_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service_check_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /service_check_details/1
  # PUT /service_check_details/1.xml
  def update
    @service_check_detail = ServiceCheckDetail.find(params[:id])

    respond_to do |format|
      if @service_check_detail.update_attributes(params[:service_check_detail])
        flash[:notice] = 'ServiceCheckDetail was successfully updated.'
        format.html { redirect_to(@service_check_detail) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service_check_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /service_check_details/1
  # DELETE /service_check_details/1.xml
  def destroy
    @service_check_detail = ServiceCheckDetail.find(params[:id])
    @service_check_detail.destroy

    respond_to do |format|
      format.html { redirect_to(service_check_details_url) }
      format.xml  { head :ok }
    end
  end
end
