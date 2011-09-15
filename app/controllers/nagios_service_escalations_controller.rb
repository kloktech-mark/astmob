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
class NagiosServiceEscalationsController < ApplicationController
  # GET /nagios_service_escalations
  # GET /nagios_service_escalations.xml
  def index
    # Sort them by group id and name
    @nagios_service_escalations = NagiosServiceEscalation.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nagios_service_escalations }
    end
  end

  # GET /nagios_service_escalations/1
  # GET /nagios_service_escalations/1.xml
  def show
    @nagios_service_escalation = NagiosServiceEscalation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nagios_service_escalation }
    end
  end

  # GET /nagios_service_escalations/new
  # GET /nagios_service_escalations/new.xml
  def new
    @nagios_service_escalation = NagiosServiceEscalation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nagios_service_escalation }
    end
  end

  # GET /nagios_service_escalations/1/edit
  def edit
    @nagios_service_escalation = NagiosServiceEscalation.find(params[:id])
  end

  # POST /nagios_service_escalations
  # POST /nagios_service_escalations.xml
  def create
    @nagios_service_escalation = NagiosServiceEscalation.new(params[:nagios_service_escalation])

    respond_to do |format|
      if @nagios_service_escalation.save
        flash[:notice] = 'NagiosServiceEscalation was successfully created.'
        format.html { redirect_to(@nagios_service_escalation) }
        format.xml  { render :xml => @nagios_service_escalation, :status => :created, :location => @nagios_service_escalation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nagios_service_escalation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nagios_service_escalations/1
  # PUT /nagios_service_escalations/1.xml
  def update
    @nagios_service_escalation = NagiosServiceEscalation.find(params[:id])

    respond_to do |format|
      if @nagios_service_escalation.update_attributes(params[:nagios_service_escalation])
        flash[:notice] = 'NagiosServiceEscalation was successfully updated.'
        format.html { redirect_to(@nagios_service_escalation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nagios_service_escalation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nagios_service_escalations/1
  # DELETE /nagios_service_escalations/1.xml
  def destroy
    @nagios_service_escalation = NagiosServiceEscalation.find(params[:id])
    @nagios_service_escalation.destroy

    respond_to do |format|
      format.html { redirect_to(nagios_service_escalations_url) }
      format.xml  { head :ok }
    end
  end
end
