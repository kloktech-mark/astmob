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
class CpuDetailsController < ApplicationController
  # GET /cpu_details
  # GET /cpu_details.xml
  def index
    @cpu_details = CpuDetails.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cpu_details }
    end
  end

  # GET /cpu_details/1
  # GET /cpu_details/1.xml
  def show
    @cpu_details = CpuDetails.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cpu_details }
    end
  end

  # GET /cpu_details/new
  # GET /cpu_details/new.xml
  def new
    @cpu_details = CpuDetails.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cpu_details }
    end
  end

  # GET /cpu_details/1/edit
  def edit
    @cpu_details = CpuDetails.find(params[:id])
  end

  # POST /cpu_details
  # POST /cpu_details.xml
  def create
    @cpu_details = CpuDetails.new(params[:cpu_details])

    respond_to do |format|
      if @cpu_details.save
        flash[:notice] = 'CpuDetails was successfully created.'
        format.html { redirect_to(@cpu_details) }
        format.xml  { render :xml => @cpu_details, :status => :created, :location => @cpu_details }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cpu_details.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cpu_details/1
  # PUT /cpu_details/1.xml
  def update
    @cpu_details = CpuDetails.find(params[:id])

    respond_to do |format|
      if @cpu_details.update_attributes(params[:cpu_details])
        flash[:notice] = 'CpuDetails was successfully updated.'
        format.html { redirect_to(@cpu_details) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cpu_details.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cpu_details/1
  # DELETE /cpu_details/1.xml
  def destroy
    @cpu_details = CpuDetails.find(params[:id])
    @cpu_details.destroy

    respond_to do |format|
      format.html { redirect_to(cpu_details_url) }
      format.xml  { head :ok }
    end
  end
end
