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
class ServiceContainerDetailsController < ApplicationController
  # GET /service_container_details
  # GET /service_container_details.xml
  def index
    @service_container_details = ServiceContainerDetail.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @service_container_details }
    end
  end

  # GET /service_container_details/1
  # GET /service_container_details/1.xml
  def show
    @service_container_detail = ServiceContainerDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service_container_detail }
    end
  end

  # GET /service_container_details/new
  # GET /service_container_details/new.xml
  def new
    @service_container_detail = ServiceContainerDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service_container_detail }
    end
  end

  # GET /service_container_details/1/edit
  def edit
    @service_container_detail = ServiceContainerDetail.find(params[:id])
  end

  # POST /service_container_details
  # POST /service_container_details.xml
  def create
    @service_container_detail = ServiceContainerDetail.new(params[:service_container_detail])

    respond_to do |format|
      if @service_container_detail.save
        flash[:notice] = 'ServiceContainerDetail was successfully created.'
        format.html { redirect_to(@service_container_detail) }
        format.xml  { render :xml => @service_container_detail, :status => :created, :location => @service_container_detail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service_container_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /service_container_details/1
  # PUT /service_container_details/1.xml
  def update
    @service_container_detail = ServiceContainerDetail.find(params[:id])

    respond_to do |format|
      if @service_container_detail.update_attributes(params[:service_container_detail])
        flash[:notice] = 'ServiceContainerDetail was successfully updated.'
        format.html { redirect_to(@service_container_detail) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service_container_detail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /service_container_details/1
  # DELETE /service_container_details/1.xml
  def destroy
    @service_container_detail = ServiceContainerDetail.find(params[:id])
    @service_container_detail.destroy

    respond_to do |format|
      format.html { redirect_to(service_container_details_url) }
      format.xml  { head :ok }
    end
  end
end
