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
class MemoryModelsController < ApplicationController
  # GET /memory_models
  # GET /memory_models.xml
  def index
    @memory_models = MemoryModels.find(:all)

    respond_to do |format|
      
      format.html # index.html.erb
      format.xml  { render :xml => @memory_models }
    end
  end

  # GET /memory_models/1
  # GET /memory_models/1.xml
  def show
    @memory_models = MemoryModels.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @memory_models }
    end
  end

  # GET /memory_models/new
  # GET /memory_models/new.xml
  def new
    @memory_models = MemoryModels.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @memory_models }
    end
  end

  # GET /memory_models/1/edit
  def edit
    @memory_models = MemoryModels.find(params[:id])
  end

  # POST /memory_models
  # POST /memory_models.xml
  def create
    @memory_models = MemoryModels.new(params[:memory_models])

    respond_to do |format|
      if @memory_models.save
        flash[:notice] = 'MemoryModels was successfully created.'
        format.html { redirect_to(@memory_models) }
        format.xml  { render :xml => @memory_models, :status => :created, :location => @memory_models }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @memory_models.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /memory_models/1
  # PUT /memory_models/1.xml
  def update
    @memory_models = MemoryModels.find(params[:id])

    respond_to do |format|
      if @memory_models.update_attributes(params[:memory_models])
        flash[:notice] = 'MemoryModels was successfully updated.'
        format.html { redirect_to(@memory_models) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @memory_models.errors, :status => :unprocessable_entity }
      end
    end
  end
 def 
  # DELETE /memory_models/1
  # DELETE /memory_models/1.xml
  def destroy
    @memory_models = MemoryModels.find(params[:id])
    @memory_models.destroy

    respond_to do |format|
      format.html { redirect_to(memory_models_url) }
      format.xml  { head :ok }
    end
  end
end
