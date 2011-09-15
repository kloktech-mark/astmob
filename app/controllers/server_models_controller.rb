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
class ServerModelsController < ApplicationController
  # GET /server_models
  # GET /server_models.xml
  def index
    @server_models = ServerModel.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @server_models }
    end
  end

  # GET /server_models/1
  # GET /server_models/1.xml
  def show
    @server_model = ServerModel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @server_model }
    end
  end

  # GET /server_models/new
  # GET /server_models/new.xml
  def new
    @server_model = ServerModel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @server_model }
    end
  end

  # GET /server_models/1/edit
  def edit
    @server_model = ServerModel.find(params[:id])
  end

  # POST /server_models
  # POST /server_models.xml
  def create
    @server_model = ServerModel.new(params[:server_model])

    respond_to do |format|
      if @server_model.save
        flash[:notice] = 'ServerModel was successfully created.'
        format.html { redirect_to(@server_model) }
        format.xml  { render :xml => @server_model, :status => :created, :location => @server_model }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @server_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /server_models/1
  # PUT /server_models/1.xml
  def update
    @server_model = ServerModel.find(params[:id])

    respond_to do |format|
      if @server_model.update_attributes(params[:server_model])
        flash[:notice] = 'ServerModel was successfully updated.'
        format.html { redirect_to(@server_model) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @server_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /server_models/1
  # DELETE /server_models/1.xml
  def destroy
    @server_model = ServerModel.find(params[:id])
    @server_model.destroy

    respond_to do |format|
      format.html { redirect_to(server_models_url) }
      format.xml  { head :ok }
    end
  end
end
