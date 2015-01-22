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
class NetworkModelsController < ApplicationController
  # GET /network_models
  # GET /network_models.xml
  def index
    @network_models = NetworkModel.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @network_models }
    end
  end

  # GET /network_models/1
  # GET /network_models/1.xml
  def show
    @network_model = NetworkModel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @network_model }
    end
  end

  # GET /network_models/new
  # GET /network_models/new.xml
  def new
    @network_model = NetworkModel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @network_model }
    end
  end

  # GET /network_models/1/edit
  def edit
    @network_model = NetworkModel.find(params[:id])
  end

  # POST /network_models
  # POST /network_models.xml
  def create
    @network_model = NetworkModel.new(params[:network_model])

    respond_to do |format|
      if @network_model.save
        flash[:notice] = 'NetworkModel was successfully created.'
        format.html { redirect_to(@network_model) }
        format.xml  { render :xml => @network_model, :status => :created, :location => @network_model }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @network_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /network_models/1
  # PUT /network_models/1.xml
  def update
    @network_model = NetworkModel.find(params[:id])

    respond_to do |format|
      if @network_model.update_attributes(params[:network_model])
        flash[:notice] = 'NetworkModel was successfully updated.'
        format.html { render :action => "edit" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @network_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /network_models/1
  # DELETE /network_models/1.xml
  def destroy
    @network_model = NetworkModel.find(params[:id])
    @network_model.destroy

    respond_to do |format|
      format.html { redirect_to(network_models_url) }
      format.xml  { head :ok }
    end
  end
end
