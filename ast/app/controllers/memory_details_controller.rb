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
class MemoryDetailsController < ApplicationController
  # GET /memory_details
  # GET /memory_details.xml
  def index
    @memory_details = MemoryDetails.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @memory_details }
    end
  end

  # GET /memory_details/1
  # GET /memory_details/1.xml
  def show
    @memory_details = MemoryDetails.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @memory_details }
    end
  end

  # GET /memory_details/new
  # GET /memory_details/new.xml
  def new
    @memory_details = MemoryDetails.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @memory_details }
    end
  end

  # GET /memory_details/1/edit
  def edit
    @memory_details = MemoryDetails.find(params[:id])
  end

  # POST /memory_details
  # POST /memory_details.xml
  def create
    @memory_details = MemoryDetails.new(params[:memory_details])

    respond_to do |format|
      if @memory_details.save
        flash[:notice] = 'MemoryDetails was successfully created.'
        format.html { redirect_to(@memory_details) }
        format.xml  { render :xml => @memory_details, :status => :created, :location => @memory_details }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @memory_details.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /memory_details/1
  # PUT /memory_details/1.xml
  def update
    @memory_details = MemoryDetails.find(params[:id])

    respond_to do |format|
      if @memory_details.update_attributes(params[:memory_details])
        flash[:notice] = 'MemoryDetails was successfully updated.'
        format.html { redirect_to(@memory_details) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @memory_details.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /memory_details/1
  # DELETE /memory_details/1.xml
  def destroy
    @memory_details = MemoryDetails.find(params[:id])
    @memory_details.destroy

    respond_to do |format|
      format.html { redirect_to(memory_details_url) }
      format.xml  { head :ok }
    end
  end
end
