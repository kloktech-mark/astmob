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
class NagiosHostTemplatesController < ApplicationController
  # GET /nagios_host_templates
  # GET /nagios_host_templates.xml
  def index
    @nagios_host_templates = NagiosHostTemplate.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nagios_host_templates }
    end
  end

  # GET /nagios_host_templates/1
  # GET /nagios_host_templates/1.xml
  def show
    @nagios_host_template = NagiosHostTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nagios_host_template }
    end
  end

  # GET /nagios_host_templates/new
  # GET /nagios_host_templates/new.xml
  def new
    @nagios_host_template = NagiosHostTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nagios_host_template }
    end
  end

  # GET /nagios_host_templates/1/edit
  def edit
    @nagios_host_template = NagiosHostTemplate.find(params[:id])
  end

  # POST /nagios_host_templates
  # POST /nagios_host_templates.xml
  def create
    @nagios_host_template = NagiosHostTemplate.new(params[:nagios_host_template])

    respond_to do |format|
      if @nagios_host_template.save
        flash[:notice] = 'NagiosHostTemplate was successfully created.'
        format.html { redirect_to(@nagios_host_template) }
        format.xml  { render :xml => @nagios_host_template, :status => :created, :location => @nagios_host_template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nagios_host_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nagios_host_templates/1
  # PUT /nagios_host_templates/1.xml
  def update
    @nagios_host_template = NagiosHostTemplate.find(params[:id])

    respond_to do |format|
      if @nagios_host_template.update_attributes(params[:nagios_host_template])
        flash[:notice] = 'NagiosHostTemplate was successfully updated.'
        format.html { redirect_to(@nagios_host_template) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nagios_host_template.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nagios_host_templates/1
  # DELETE /nagios_host_templates/1.xml
  def destroy
    @nagios_host_template = NagiosHostTemplate.find(params[:id])
    @nagios_host_template.destroy

    respond_to do |format|
      format.html { redirect_to(nagios_host_templates_url) }
      format.xml  { head :ok }
    end
  end
end
