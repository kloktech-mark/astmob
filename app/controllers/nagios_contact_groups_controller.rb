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
class NagiosContactGroupsController < ApplicationController
  # GET /nagios_contact_groups
  # GET /nagios_contact_groups.xml
  def index
    @nagios_contact_groups = NagiosContactGroup.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nagios_contact_groups }
    end
  end

  # GET /nagios_contact_groups/1
  # GET /nagios_contact_groups/1.xml
  def show
    @nagios_contact_group = NagiosContactGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nagios_contact_group }
    end
  end

  # GET /nagios_contact_groups/new
  # GET /nagios_contact_groups/new.xml
  def new
    @nagios_contact_group = NagiosContactGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nagios_contact_group }
    end
  end

  # GET /nagios_contact_groups/1/edit
  def edit
    @nagios_contact_group = NagiosContactGroup.find(params[:id])
  end

  # POST /nagios_contact_groups
  # POST /nagios_contact_groups.xml
  def create
    @nagios_contact_group = NagiosContactGroup.new(params[:nagios_contact_group])

    respond_to do |format|
      if @nagios_contact_group.save
        flash[:notice] = 'NagiosContactGroup was successfully created.'
        format.html { redirect_to(@nagios_contact_group) }
        format.xml  { render :xml => @nagios_contact_group, :status => :created, :location => @nagios_contact_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nagios_contact_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nagios_contact_groups/1
  # PUT /nagios_contact_groups/1.xml
  def update
    @nagios_contact_group = NagiosContactGroup.find(params[:id])

    respond_to do |format|
      if @nagios_contact_group.update_attributes(params[:nagios_contact_group])
        flash[:notice] = 'NagiosContactGroup was successfully updated.'
        format.html { redirect_to(@nagios_contact_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nagios_contact_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nagios_contact_groups/1
  # DELETE /nagios_contact_groups/1.xml
  def destroy
    @nagios_contact_group = NagiosContactGroup.find(params[:id])
    @nagios_contact_group.destroy

    respond_to do |format|
      format.html { redirect_to(nagios_contact_groups_url) }
      format.xml  { head :ok }
    end
  end
end
