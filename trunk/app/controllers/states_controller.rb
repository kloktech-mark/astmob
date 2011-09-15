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
class StatesController < ApplicationController
  # GET /states
  # GET /states.xml
  def index
    @states = State.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @states }
    end
  end

  # GET /states/1
  # GET /states/1.xml
  def show
    @state = State.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @state }
    end
  end

  # GET /states/new
  # GET /states/new.xml
  def new
    @state = State.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @state }
    end
  end

  # GET /states/1/edit
  def edit
    @state = State.find(params[:id])
  end

  # POST /states
  # POST /states.xml
  def create
    @state = State.new(params[:state])

    respond_to do |format|
      if @state.save
        flash[:notice] = 'State was successfully created.'
        format.html { redirect_to(@state) }
        format.xml  { render :xml => @state, :status => :created, :location => @state }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @state.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /states/1
  # PUT /states/1.xml
  def update
    @state = State.find(params[:id])

    respond_to do |format|
      if @state.update_attributes(params[:state])
        flash[:notice] = 'State was successfully updated.'
        format.html { redirect_to(@state) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @state.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /states/1
  # DELETE /states/1.xml
  def destroy
    @state = State.find(params[:id])
    @state.destroy

    respond_to do |format|
      format.html { redirect_to(states_url) }
      format.xml  { head :ok }
    end
  end
end
