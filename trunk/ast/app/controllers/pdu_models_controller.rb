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
class PduModelsController < ApplicationController
  # GET /pdu_models
  # GET /pdu_models.xml
  def index
    @pdu_models = PduModel.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pdu_models }
    end
  end

  # GET /pdu_models/1
  # GET /pdu_models/1.xml
  def show
    @pdu_model = PduModel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pdu_model }
    end
  end

  # GET /pdu_models/new
  # GET /pdu_models/new.xml
  def new
    @pdu_model = PduModel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pdu_model }
    end
  end

  # GET /pdu_models/1/edit
  def edit
    @pdu_model = PduModel.find(params[:id])
  end

  # POST /pdu_models
  # POST /pdu_models.xml
  def create
    @pdu_model = PduModel.new(params[:pdu_model])

    respond_to do |format|
      if @pdu_model.save
        flash[:notice] = 'PduModel was successfully created.'
        format.html { redirect_to(@pdu_model) }
        format.xml  { render :xml => @pdu_model, :status => :created, :location => @pdu_model }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pdu_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pdu_models/1
  # PUT /pdu_models/1.xml
  def update
    @pdu_model = PduModel.find(params[:id])
    respond_to do |format|
      if @pdu_model.update_attributes(params[:pdu_model])
        flash[:notice] = 'PduModel was successfully updated.'
        format.html { redirect_to(@pdu_model) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pdu_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pdu_models/1
  # DELETE /pdu_models/1.xml
  def destroy
    @pdu_model = PduModel.find(params[:id])
    @pdu_model.destroy

    respond_to do |format|
      format.html { redirect_to(pdu_models_url) }
      format.xml  { head :ok }
    end
  end
  
end
