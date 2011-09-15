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
class DiskModelsController < ApplicationController
  # GET /disk_models
  # GET /disk_models.xml
  def index
    @disk_models = DiskModel.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @disk_models }
    end
  end

  # GET /disk_models/1
  # GET /disk_models/1.xml
  def show
    @disk_model = DiskModel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @disk_model }
    end
  end

  # GET /disk_models/new
  # GET /disk_models/new.xml
  def new
    @disk_model = DiskModel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @disk_model }
    end
  end

  # GET /disk_models/1/edit
  def edit
    @disk_model = DiskModel.find(params[:id])
  end

  # POST /disk_models
  # POST /disk_models.xml
  def create
    @disk_model = DiskModel.new(params[:disk_model])

    respond_to do |format|
      if @disk_model.save
        flash[:notice] = 'DiskModel was successfully created.'
        format.html { redirect_to(@disk_model) }
        format.xml  { render :xml => @disk_model, :status => :created, :location => @disk_model }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @disk_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /disk_models/1
  # PUT /disk_models/1.xml
  def update
    @disk_model = DiskModel.find(params[:id])

    respond_to do |format|
      if @disk_model.update_attributes(params[:disk_model])
        flash[:notice] = 'DiskModel was successfully updated.'
        format.html { redirect_to(@disk_model) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @disk_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /disk_models/1
  # DELETE /disk_models/1.xml
  def destroy
    @disk_model = DiskModel.find(params[:id])
    @disk_model.destroy

    respond_to do |format|
      format.html { redirect_to(disk_models_url) }
      format.xml  { head :ok }
    end
  end
end
