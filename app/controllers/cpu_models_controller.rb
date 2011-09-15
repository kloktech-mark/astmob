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
class CpuModelsController < ApplicationController
  # GET /cpu_models
  # GET /cpu_models.xml
  def index
    @cpu_models = CpuModel.find(:all)

    respond_to do |format|
      
      format.html # index.html.erb
      format.xml  { render :xml => @cpu_models }
    end
  end

  # GET /cpu_models/1
  # GET /cpu_models/1.xml
  def show
    @cpu_models = CpuModel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cpu_models }
    end
  end

  # GET /cpu_models/new
  # GET /cpu_models/new.xml
  def new
    @cpu_models = CpuModel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cpu_models }
    end
  end

  # GET /cpu_models/1/edit
  def edit
    @cpu_models = CpuModel.find(params[:id])
  end

  # POST /cpu_models
  # POST /cpu_models.xml
  def create
    @cpu_models = CpuModel.new(params[:cpu_models])

    respond_to do |format|
      if @cpu_models.save
        flash[:notice] = 'CpuModel was successfully created.'
        format.html { redirect_to(@cpu_models) }
        format.xml  { render :xml => @cpu_models, :status => :created, :location => @cpu_models }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cpu_models.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cpu_models/1
  # PUT /cpu_models/1.xml
  def update
    @cpu_models = CpuModel.find(params[:id])

    respond_to do |format|
      if @cpu_models.update_attributes(params[:cpu_models])
        flash[:notice] = 'CpuModel was successfully updated.'
        format.html { redirect_to(@cpu_models) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cpu_models.errors, :status => :unprocessable_entity }
      end
    end
  end
 def 
  # DELETE /cpu_models/1
  # DELETE /cpu_models/1.xml
  def destroy
    @cpu_models = CpuModel.find(params[:id])
    @cpu_models.destroy

    respond_to do |format|
      format.html { redirect_to(cpu_models_url) }
      format.xml  { head :ok }
    end
  end
end
