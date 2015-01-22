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
class VideoModelsController < ApplicationController
  # GET /video_models
  # GET /video_models.xml
  def index
    @video_models = VideoModel.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @video_models }
    end
  end

  # GET /video_models/1
  # GET /video_models/1.xml
  def show
    @video_model = VideoModel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @video_model }
    end
  end

  # GET /video_models/new
  # GET /video_models/new.xml
  def new
    @video_model = VideoModel.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @video_model }
    end
  end

  # GET /video_models/1/edit
  def edit
    @video_model = VideoModel.find(params[:id])
  end

  # POST /video_models
  # POST /video_models.xml
  def create
    @video_model = VideoModel.new(params[:video_model])

    respond_to do |format|
      if @video_model.save
        flash[:notice] = 'VideoModel was successfully created.'
        format.html { redirect_to(@video_model) }
        format.xml  { render :xml => @video_model, :status => :created, :location => @video_model }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @video_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /video_models/1
  # PUT /video_models/1.xml
  def update
    @video_model = VideoModel.find(params[:id])

    respond_to do |format|
      if @video_model.update_attributes(params[:video_model])
        flash[:notice] = 'VideoModel was successfully updated.'
        format.html { render :action => "edit" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /video_models/1
  # DELETE /video_models/1.xml
  def destroy
    @video_model = VideoModel.find(params[:id])
    @video_model.destroy

    respond_to do |format|
      format.html { redirect_to(video_models_url) }
      format.xml  { head :ok }
    end
  end
end
