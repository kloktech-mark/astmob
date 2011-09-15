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
class NagiosHostGroupsController < ApplicationController
  
  require 'networking'

  def self.in_place_loader_for(object, attribute, options ={})
    define_method("get_#{object}_#{attribute}") do
      @item = object.to_s.camelize.constantize.find(params[:id])
      render :text => @item.send(attribute) || "[No Value]"
    end
  end
  
  in_place_edit_for :nagios_host_group, :hosts
  
  in_place_loader_for :nagios_host_group, :hosts
  
  # GET /nagios_host_groups
  # GET /nagios_host_groups.xml
  def index
    @nagios_host_groups = NagiosHostGroup.find(:all, :order => "name")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nagios_host_groups }
    end
  end

  # GET /nagios_host_groups/1
  # GET /nagios_host_groups/1.xml
  def show
    @nagios_host_group = NagiosHostGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nagios_host_group }
    end
  end

  # GET /nagios_host_groups/new
  # GET /nagios_host_groups/new.xml
  def new
    @nagios_host_group = NagiosHostGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nagios_host_group }
    end
  end

  # GET /nagios_host_groups/1/edit
  def edit
    @nagios_host_group = NagiosHostGroup.find(params[:id])
  end

  # POST /nagios_host_groups
  # POST /nagios_host_groups.xml
  def create
    @nagios_host_group = NagiosHostGroup.new(params[:nagios_host_group])

    respond_to do |format|
      if @nagios_host_group.save
        flash[:notice] = 'NagiosHostGroup was successfully created.'
        format.html { redirect_to(@nagios_host_group) }
        format.xml  { render :xml => @nagios_host_group, :status => :created, :location => @nagios_host_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nagios_host_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nagios_host_groups/1
  # PUT /nagios_host_groups/1.xml
  def update
    @nagios_host_group = NagiosHostGroup.find(params[:id])

    respond_to do |format|
      if @nagios_host_group.update_attributes(params[:nagios_host_group])
        flash[:notice] = 'NagiosHostGroup was successfully updated.'
        format.html { render :action => "edit" }
#        format.html { redirect_to(@nagios_host_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nagios_host_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nagios_host_groups/1
  # DELETE /nagios_host_groups/1.xml
  def destroy
    @nagios_host_group = NagiosHostGroup.find(params[:id])
    @nagios_host_group.destroy

    respond_to do |format|
      format.html { redirect_to(nagios_host_groups_url) }
      format.xml  { head :ok }
    end
  end
  
  # Strip out non-alphanumeric characters and rebuild the string
  # with camel case.
  def strip_nonalpha_chars(word, holder_array)
    # Match non-words or if it's underscore.
    regexp = Regexp.new(/\W|\_/)
    match_true = regexp.match(word)
    if match_true
      delim_pos = (/\W|\_/ =~ word)
      delimiter = word.split(//)[delim_pos]
      temp_array = word.split(delimiter)
      temp_array.each { |part|
        strip_nonalpha_chars(part, holder_array)
      }
    else
      regalpha = Regexp.new(/[a-z]/)
      if !regalpha.match(word.split(//)[0])
        holder_array << word 
      else
        holder_array << word.capitalize!
      end
    end
    return holder_array
  end
  
  # Build nagios hostgroup from db
  def build_hostgroup
    # Find all group, find the matching host of each group,
    # break it up into colo.
    
    # hostgroup + misc. msg
    @o = ''
    # hosts
    @m = ''
    # services and escalations
    @s = ''
    
    
    
    skip_groups = []
    group_members = {}
    
    colo_name = params[:src].split(".")[1]
    
    # Find the colo object by the name
    colo = Colo.find_by_name(colo_name)
    
    if colo.nil?
      raise "No colo found from src hostname"
    end
    
    @o += "# request for " + colo_name + "\n"
    nagios_host_groups = NagiosHostGroup.find(:all)
    
    for host_group in nagios_host_groups
      assets = find_nagios_match(host_group,"")
      if ! assets.nil?
        
        asset_list = []
        for asset in assets
          # If asset type is Vip, then we will be monitoring it from every colo
          # Doing something special.  Since Vip itself doesn't have colo, its colo then inherits from whatever colo its HA belongs to.
          if asset.resource_type == "Vip"
            if  asset.resource.colo == colo or asset.name =~ /\.com$/
              asset_list << asset
            end

          # Find if there is any asset belongs to the colo we're interested in
          elsif asset.colo == colo
            asset_list << asset
          end
        end
        
        assets = asset_list
        
        # If we have hosts in this hostgroup
        if assets.length > 0 
          group_members[host_group.name] = []
          @o += "define hostgroup {\n"
          @o += "  hostgroup_name #{host_group.name}\n"
          @o += "  alias #{host_group.name}\n"
          @o += "  members "
          # Build membership for hostgroup
          @o += assets.collect{|a| a.name}.join(",") + "\n"          
          @o += "}\n"             
  
          # Build asset information
          for asset in assets
            group_members[host_group.name] << asset.name
            @m += "define host {\n"
            @m += "  host_name #{asset.name}\n"
            @m += "  alias #{asset.name}\n"

            if ! asset.primary_interface.nil? 
              @m += "  address #{asset.primary_interface.ip_to_string}\n"  
            else
              @m += "  address #{asset.name}\n"
            end
           
            if ( host_group.nagios_host_template.nil?)
              @m += "  use generic-host\n"
            else
              @m += "  use #{host_group.nagios_host_template.name}\n"
            end
            
            @m += "}\n"
          end 
                      
          # Now we render services for original-style checks
          for service_detail in host_group.nagios_service_details
            service = service_detail.nagios_service
            @s += "define service {\n"
            @s += "  service_description #{service.name}\n"
            @s += "  use #{service.nagios_service_template.name}\n"
            @s += "  hostgroup_name #{host_group.name}\n"
            @s += "  check_command #{service.check_command}\n"
            
            # Build the _wiki_url.
            wiki_obj = "#{service.name}"
            words_array = []
            strip_nonalpha_chars(wiki_obj, words_array)
            wiki_name = "Alert" + words_array.join('')
            
            @s += "  _wiki_url http://wiki/Main/" + wiki_name + "\n"
            @s += "}\n"

            # Build escalation for this group
            for escalation in service_detail.nagios_service_escalations 
              @s += "define serviceescalation {\n"
              @s += "  use #{escalation.nagios_service_escalation_template.name}\n"
              @s += "  hostgroup_name #{host_group.name}\n"
              @s += "  service_description #{escalation.nagios_service_detail.nagios_service.name}\n"
              @s += "  contact_groups " + escalation.nagios_contact_groups.collect{|a| a.name}.join(",") + "\n"
              @s += "}\n"
            end            
            
          end
          
          # Now render services for service_containers
          for container_detail in host_group.service_container_details
            service = container_detail.service_container
            nst = NagiosServiceTemplate.find(:first, :conditions => ["id = '#{service.nagios_service_template_id}'"]).name rescue nil           
            # Create the version for nagios dashboard. The name used to be suffixed with -internal. Not any more!
            @s += "define service {\n"
            @s += "  service_description #{service.name}\n"
            @s += "  use #{nst}\n"
            @s += "  hostgroup_name #{host_group.name}\n"
            @s += "  check_command #{service.check_command}\n"
            
            # Build the _wiki_url.
            wiki_obj = "#{service.name}"
            words_array = []
            strip_nonalpha_chars(wiki_obj, words_array)
            wiki_name = "Alert" + words_array.join('')
            
            @s += "  _wiki_url http://wiki/Main/" + wiki_name + "\n"
            @s += "}\n"
          end
        else
          skip_groups << host_group.name
        end 
      else
        skip_groups << host_group.name
      end   
    end
    
    # Now let's build service group.
    for service_group in NagiosServiceGroup.find(:all)
    
      g = h = ''
      g += "define servicegroup {\n"
      g += "  servicegroup_name #{service_group.name}\n"
      g += "  alias #{service_group.name}\n"
      g += "  members "
      
      for detail in service_group.nagios_service_group_details


        if ! skip_groups.include?(detail.nagios_host_group.name)
          for member in group_members[detail.nagios_host_group.name]
            h += "#{member},#{detail.nagios_service.name},"
          end
        end
        
      end

      if !h.empty?
        # Remember to chop last comma off member
        @s += g + h.chop + "\n  }\n"
      end
      
      
    end
    
    # Append host information into total output
    @o += @m 
    
    @o += @s
    
    
    
    # Render partial so we don't get any layout and menu
    render :partial => 'build_hostgroup', :layout => false, :object => @o
  end
  
  # Return a list of host
  def find_hosts

    # Initialize output buffer
    @o = ''
    
    hostgroup_name = params[:name]
    
    nagios_host_group = NagiosHostGroup.find(:first, :conditions => "name = '#{hostgroup_name}'")
    
    if nagios_host_group.nil?
      @o += "ERR: No hostgroup found"
      
    else
      assets = find_nagios_match(nagios_host_group,"")
      
      @o += assets.collect{|a| a.name}.join("\n")

    end

    # Render partial so we don't get any layout and menu
    render :partial => 'build_hostgroup', :layout => false, :object => @o

  
  end

    
end
