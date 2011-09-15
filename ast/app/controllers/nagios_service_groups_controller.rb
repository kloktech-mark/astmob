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
class NagiosServiceGroupsController < ApplicationController
  # GET /nagios_service_groups
  # GET /nagios_service_groups.xml
  def index
    @nagios_service_groups = NagiosServiceGroup.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nagios_service_groups }
    end
  end

  # GET /nagios_service_groups/1
  # GET /nagios_service_groups/1.xml
  def show
    @nagios_service_group = NagiosServiceGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nagios_service_group }
    end
  end

  # GET /nagios_service_groups/new
  # GET /nagios_service_groups/new.xml
  def new
    @nagios_service_group = NagiosServiceGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nagios_service_group }
    end
  end

  # GET /nagios_service_groups/1/edit
  def edit
    @nagios_service_group = NagiosServiceGroup.find(params[:id])
  end

  # POST /nagios_service_groups
  # POST /nagios_service_groups.xml
  def create
    @nagios_service_group = NagiosServiceGroup.new(params[:nagios_service_group])

    respond_to do |format|
      if @nagios_service_group.save
        flash[:notice] = 'NagiosServiceGroup was successfully created.'
        format.html { redirect_to(@nagios_service_group) }
        format.xml  { render :xml => @nagios_service_group, :status => :created, :location => @nagios_service_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nagios_service_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nagios_service_groups/1
  # PUT /nagios_service_groups/1.xml
  def update
    @nagios_service_group = NagiosServiceGroup.find(params[:id])

    respond_to do |format|
      if @nagios_service_group.update_attributes(params[:nagios_service_group])
        flash[:notice] = 'NagiosServiceGroup was successfully updated.'
        format.html { redirect_to(@nagios_service_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nagios_service_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nagios_service_groups/1
  # DELETE /nagios_service_groups/1.xml
  def destroy
    @nagios_service_group = NagiosServiceGroup.find(params[:id])
    @nagios_service_group.destroy

    respond_to do |format|
      format.html { redirect_to(nagios_service_groups_url) }
      format.xml  { head :ok }
    end
  end
  
  # Ajax call to build service selection dynamically based on selected hostgroup
  def get_services
    
    if params[:nagios_service_group_details][:nagios_host_group_id].empty?
      @services = []
    else
      # Find hostgroup
      host_group = NagiosHostGroup.find(params[:nagios_service_group_details][:nagios_host_group_id])
      # Find service group
      service_group = NagiosServiceGroup.find(params[:id])
      # Find service under the hostgroup that's already in the service group
      existing_details = host_group.nagios_service_group_details.find_all{|a| a.nagios_service_group == service_group}.collect{|a| a.nagios_service.id}
      @services = host_group.nagios_services.find_all{|a| !existing_details.include?(a.id)}
    end
    
    render :partial => 'nagios_service_group_details/mini_service_select', :layout => false, :object => @services
    
  end
  
  def add_details

#    raise params.inspect
    @service_group = NagiosServiceGroup.find(params[:id])
    
    if ! params[:nagios_service_group_details][:nagios_host_group_id].empty?
          
      host_group = NagiosHostGroup.find(params[:nagios_service_group_details][:nagios_host_group_id])
      
      if !params[:nagios_service_group_details][:nagios_service_id].nil? and params[:nagios_service_group_details][:nagios_service_id].length > 0
        for service_id in params[:nagios_service_group_details][:nagios_service_id]
          sgd = NagiosServiceGroupDetail.new(:nagios_host_group_id => params[:nagios_service_group_details][:nagios_host_group_id],
                                             :nagios_service_id => service_id)
          @service_group.nagios_service_group_details << sgd
          
          @service_group.save
          
        end
      end
    
    end




    render :partial => 'nagios_service_group_details/mini_edit', :layout => false, :object => @service_group
  end

end
