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
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require "will_paginate" 
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '9d2eebad4bc10953ad230a2db7c61251'

  
#  audit DnsZone, Vip, NagiosHostGroup, NagiosService, ServiceContainer, Asset => { :except => :ocs_history }, Interface => { :parent => :asset }, DnsCnameDetail => {:parent => :dns_cname}
  
  # Find nagios hostgroup
  def nagios_find_my_hostgroup(hostname,hostgroup_map = nil)
    
    if hostgroup_map.nil?
      hostgroup_map = nagios_hostgroup_map
    end
    
    hostgroup_map.each { | key, value|
      if value.include?(hostname)
        return key
      end
    }

    return nil
    
  end

  # Build a hash with nagios hosts in it.
  def nagios_hostgroup_map
    
    hostgroup_map = Hash.new
    
    nagios_hostgroups = NagiosHostGroup.find(:all)
    
    for nagios_hostgroup in nagios_hostgroups
      assets = find_nagios_match(nagios_hostgroup,'')
      
      if ! assets.nil?
        hostgroup_map[nagios_hostgroup] = assets.collect { |a| a.name}
      end
      
        
    end
    
    return hostgroup_map
  end
  
  
 
  # Find matching asset given nagios host group id
  def nagios_match


    nagios_host_group = NagiosHostGroup.find(params[:id])

    # We fetch whatever is in the form so we can test
    existing_hosts = params[:nagios_host_group][:hosts]
       
    @assets = find_nagios_match(nagios_host_group,existing_hosts)
    
    respond_to do |format|
      format.html { render :partial => 'nagios_match', :layout => false, :object => @assets }
      format.xml  { head :ok }
    end    
    
  end
  
  
  # Return list of assets of maching 
  # Accept nagios_hostgroup object
  def find_nagios_match(nagios_host_group,existing = nil)

    # array of matching name
    matching = []
    
    # If no existing hosts data was passed, we'll just the object's data
    if (existing.empty?)
      if ( nagios_host_group.hosts.nil? )
        return nil
      else
        hosts = nagios_host_group.hosts.split(/\s+/)  
      end
      
    else
      hosts = existing.split(/\s+/)
    end
    
    #raise hosts.inspect
    
    
    # Build the list of hostname that we need to match against.
    for host in hosts
      # Let's see if we match somethig
      # Won't accept multiple range in one line
      if m = /^([^\[^\]]*)\[(.*)\]([^\[^\]]*)$/.match(host)
        h_head = m[1]
        h_range = m[2]
        h_tail = m[3]
        
        # Get the range
        ranges = h_range.split(",")
        
        for range in ranges
          # range regular number like "10", "1"
          if range =~ /^\d+$/
            matching << h_head + range + h_tail
          # range looking like "10-22"
          elsif range =~ /^(\d+)-(\d+)$/
            low = Regexp.last_match(1)
            high = Regexp.last_match(2)
            if low <= high
              for i in low..high
                matching << h_head + i + h_tail
              end
            else
              for i in high..low
                matching << h_head + i + h_tail
              end              
            end
          else
            flash[nagios] += "range #{range} not recognized in #{host}\n"
          end
          
        end
      # else if host has no range, we just push it in.  
      elsif host =~ /^[^\[^\]]+$/
        matching << host
      end
    end

    # Find list of asset that has name match to our matching list
    assets = Asset.find(:all).find_all {|a| matching.include?(a.name)}
            
  end

protected
  def current_user
    @user = request.env['HTTP_REMOTE_USER']
  end
  
end
