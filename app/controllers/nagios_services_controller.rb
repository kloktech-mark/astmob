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
class NagiosServicesController < ApplicationController
  # GET /nagios_services
  # GET /nagios_services.xml
  def index
    @nagios_services = NagiosService.find(:all, :order => "name")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nagios_services }
    end
  end

  # GET /nagios_services/1
  # GET /nagios_services/1.xml
  def show
    @nagios_service = NagiosService.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nagios_service }
    end
  end

  # GET /nagios_services/new
  # GET /nagios_services/new.xml
  def new
    @nagios_service = NagiosService.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nagios_service }
    end
  end

  # GET /nagios_services/1/edit
  def edit
    @nagios_service = NagiosService.find(params[:id])
  end

  # POST /nagios_services
  # POST /nagios_services.xml
  def create
    @nagios_service = NagiosService.new(params[:nagios_service])

    respond_to do |format|
      if @nagios_service.save
        flash[:notice] = 'NagiosService was successfully created.'
        format.html { redirect_to(@nagios_service) }
        format.xml  { render :xml => @nagios_service, :status => :created, :location => @nagios_service }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nagios_service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nagios_services/1
  # PUT /nagios_services/1.xml
  def update
    @nagios_service = NagiosService.find(params[:id])

    respond_to do |format|
      if @nagios_service.update_attributes(params[:nagios_service])
        flash[:notice] = 'NagiosService was successfully updated.'
        format.html { redirect_to(@nagios_service) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nagios_service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nagios_services/1
  # DELETE /nagios_services/1.xml
  def destroy
    @nagios_service = NagiosService.find(params[:id])
    @nagios_service.destroy

    respond_to do |format|
      format.html { redirect_to(nagios_services_url) }
      format.xml  { head :ok }
    end
  end
  
  # Link interface for hostgroup
  def create_detail
    #raise params.inspect
    
    @nagios_host_group = NagiosHostGroup.find(params[:id])
    
    # Create service for each selected one
    for service in params[:nagios_services][:nagios_service_id]
      if ! service.empty?
        service_detail = NagiosServiceDetail.find_or_create_by_nagios_host_group_id_and_nagios_service_id(params[:id],service)
      end
      
    end
    flash[:nagios_service] = "Service(s) added"

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @nagios_host_group }
      format.xml  { head :ok }
    end    
    
  end

  # Destroy service and escalation
  def destroy_detail
    #raise params.inspect
    service_detail = NagiosServiceDetail.find(params[:id])
    
    @nagios_host_group = service_detail.nagios_host_group
    nagios_service = service_detail.nagios_service
    
    # Destroy all service escalations under this hostgroup and this service
    NagiosServiceEscalation.destroy(service_detail.nagios_service_escalations)
    
    # Destroy service itself
    service_detail.destroy

    flash[:nagios_service] = "Service(s) deleted."

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @nagios_host_group }
      format.xml  { head :ok }
    end    
    
  end  
  
  # Delete escalation
  def destroy_service_escalation
    #raise params.inspect
    
    service_escalation = NagiosServiceEscalation.find(params[:id])
    
    @nagios_host_group = service_escalation.nagios_service_detail.nagios_host_group

    # Destroy service itself
    service_escalation.destroy

    flash[:nagios_service] = "Escalation deleted."

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @nagios_host_group }
      format.xml  { head :ok }
    end    
    
  end  
  
  
  # Link interface for hostgroup
  def create_escalation
    
    #raise params.inspect
    
    @nagios_host_group = NagiosHostGroup.find(params[:id])
    
    
    
    # Create service for each selected one
    for service in params[:nagios_services][:nagios_service_id]
      
      if ! service.empty?
        service_detail = NagiosServiceDetail.find_by_nagios_host_group_id_and_nagios_service_id(params[:id],service)
        
        # Find escalation
        escalation = NagiosServiceEscalation.find_or_create_by_nagios_service_detail_id_and_nagios_service_escalation_template_id(service_detail.id,params[:nagios_services][:nagios_service_escalation_template_id])
       
        # Add contact group to each escalation
        for contact_group in params[:nagios_services][:nagios_contact_group_id]
          
          # if contact group is not already under escalation, add it
          if ! escalation.nagios_contact_groups.collect{|a| a.id}.include?(contact_group)
            NagiosContactGroupServiceEscalationDetail.create(:nagios_contact_group_id => contact_group, :nagios_service_escalation_id => escalation.id)
          end
          
        end

      end
    end
    
    #flash[:nagios_service] = "Escalation added"

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @nagios_host_group }
      format.xml  { head :ok }
    end    
    
  end
  
end
