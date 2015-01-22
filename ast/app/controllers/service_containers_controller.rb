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
class ServiceContainersController < ApplicationController
  # GET /service_containers
  # GET /service_containers.xml
  helper_method :sort_by_relationship
  def index
    @service_containers = ServiceContainer.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @service_containers }
    end
  end

  # GET /service_containers/1
  # GET /service_containers/1.xml
  def show
    @service_container = ServiceContainer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service_container }
    end
  end

  # GET /service_containers/new
  # GET /service_containers/new.xml
  def new
    @service_container = ServiceContainer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service_container }
    end
  end

  # GET /service_containers/1/edit
  def edit
    @service_container = ServiceContainer.find(params[:id])
    
   #@service_container.service_check_details.each {|a| p "#{a.id} : #{a.service_check_id}"}
    
  end

  # POST /service_containers
  # POST /service_containers.xml
  def create
    @service_container = ServiceContainer.new(params[:service_container])

    respond_to do |format|
      if @service_container.save
        flash[:notice] = 'ServiceContainer was successfully created.'
        format.html { redirect_to(@service_container) }
        format.xml  { render :xml => @service_container, :status => :created, :location => @service_container }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service_container.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /service_containers/1
  # PUT /service_containers/1.xml
  def update
    @service_container = ServiceContainer.find(params[:id])

    respond_to do |format|
      if @service_container.update_attributes(params[:service_container])
        flash[:notice] = 'ServiceContainer was successfully updated.'
        format.html { redirect_to(@service_container) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service_container.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /service_containers/1
  # DELETE /service_containers/1.xml
  def destroy
    @service_container = ServiceContainer.find(params[:id])
    @service_container.destroy

    respond_to do |format|
      format.html { redirect_to(service_containers_url) }
      format.xml  { head :ok }
    end
  end
  
  def create_detail
    @nagios_host_group = NagiosHostGroup.find(params[:id])

    # Create service check for each selected one
    for service_container in params[:service_containers][:service_container_id]
      if ! service_container.empty?
        service_container_detail = ServiceContainerDetail.find_or_create_by_nagios_host_group_id_and_service_container_id(params[:id],service_container)
      end
      
    end
    flash[:service_container] = "Service container(s) added"

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @nagios_host_group }
      format.xml  { head :ok }
    end    
    
  end

  # Destroy service and escalation
  def destroy_detail
    #raise params.inspect
    service_container_detail = ServiceContainerDetail.find(params[:id])
    
    @nagios_host_group = service_container_detail.nagios_host_group
    service_container = service_container_detail.service_container
    
    # Destroy service itself
    service_container_detail.destroy

    flash[:service_container] = "Service container(s) deleted."

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @nagios_host_group }
      format.xml  { head :ok }
    end    
 
  end

  def build_client_containers
    # Store the json output into this variable
    @json = ''
    
    # Get the hostname from the :host param in the URL
    @hosts = params[:host]
    num_hosts = @hosts.to_a.length
    # Create an object which has the contents of hostgroups => hosts
    @nagios_host_groups = NagiosHostGroup.find(:all, :order => "name")
    @all_hosts = {}
    
    # Create the assets object and fill it with all the hosts that belongs to hostgroups with containers that have checks
    @nagios_host_groups.each do |a|
      assets = []
      assets << find_nagios_match(a,"")
      assets.each do |b|
        b.each do |c|      
          @nagios_host_group = a.id
          @service_container = ServiceContainerDetail.find_all_by_nagios_host_group_id(@nagios_host_group)
          if @service_container.length > 0
            (@all_hosts[a.id] ||= []) << c.name
          end
        end
      end
    end      

    #This should output hand-made JSON code
    arr_element = 1
    
    @hosts.each do |me|
      done = 0
      @all_hosts.each do |a, b|
        # This loop has access to the hosts within each inner array. Refer to them with c
        b.each do |c|
          if c == me and done == 0
            # Once there's a match of hostname within hostgroup, get the hostgroup id.           
            @nagios_host_group = a
            done = 1
          end
        end
      end     
      # If no match is found, skip to next
      if done == 0
        @json = "{}"
        next
      end
      @service_container = ServiceContainerDetail.find_all_by_nagios_host_group_id(@nagios_host_group)
      # Determine which containers have checks, and get rid of the ones that don't.
      @service_container.each do |a|
        @service_check = ServiceCheckDetail.find(:all, :conditions => ["service_container_id = '#{a.service_container_id}'"])          
        if @service_check.length == 0
          @service_container.delete(a)
        end
      end
      if @service_container.length > 0
        @json += "[" + "\n"  
        num_containers_processed = 0
        @service_container.each do |a|
          num_containers_processed += 1
          service_container = ServiceContainer.find(:first, :conditions => ["id = '#{a.service_container_id}'"])
          @service_check = ServiceCheckDetail.find(:all, :conditions => ["service_container_id = '#{a.service_container_id}'"])
          if @service_check.length > 0
            @json += "{" + "\n"
            @json += '"name": "' + service_container.name + '",' + "\n"
            @json += '"target_hostname": "' + me + '",' + "\n"
            @json += '"frequency": "' + service_container.frequency.to_s + '",' + "\n"
            @json += '"checks": [{' + "\n"
            chk_element = 0
            checks_to_do = 0
            @service_check.each do |b|
              service_checker = ServiceChecker.find(:first, :conditions => ["id = '#{b.service_check.service_checker_id}'"])
              if service_checker.checker_type == 0
                checks_to_do = checks_to_do + 1
              end
            end 
            @service_check.each do |b|
              service_checker = ServiceChecker.find(:first, :conditions => ["id = '#{b.service_check.service_checker_id}'"])
              if service_checker.checker_type == 0
                @json += '"name": "' + b.service_check.name+ '",' + "\n"
                if b.service_check.parent_id == 2
                  @json += '"parent": "None",' + "\n"
                else
                  parent = ServiceCheck.find(:first, :conditions => ["id = '#{b.service_check.parent_id}'"])
                  @json += '"parent": "' + parent.name + '",' + "\n"
                end
                #@json += '"frequency": ' + b.service_check.frequency.to_s + ',' + "\n"
                command_arr = b.service_check.definition.split('!')
                command_arr.push("__END_OF_COMMAND_ARRAY__")
                d = command_arr.length
                counter = 0
                s = ServiceChecker.find(:first, :conditions => ["id = '#{b.service_check.service_checker_id}'"])
                @check_command = s.home + '/' + s.command + ' '
                #while counter < d
                #  if command_arr[counter] == '$FLAG_ON$'
                #    @check_command += ''
                #  elsif command_arr[counter + 1] == '$FLAG_ON$'
                #    @check_command += command_arr[counter] + ' '
                #  elsif command_arr[counter] == '$FLAG_OFF$'
                #    @check_command += ''
                #  elsif command_arr[counter + 1] == '$FLAG_OFF$'
                #    @check_command += ''
                #  elsif command_arr[counter + 1] == ''
                #    @check_command += ''
                #  elsif command_arr[counter] == '$HN$' #This block subs the hostname for $HN$
                #    @check_command += me  + ' '    
                #  else
                #    @check_command += command_arr[counter] + ' '
                #  end
                #  counter = counter + 1
                #end
                
                while command_arr.size > 0
                #puts command_arr.inspect
                #puts command_arr[0].inspect
                #puts @check_command.inspect
                  #puts @check_command.inspect
                  if command_arr[0] == '__END_OF_COMMAND_ARRAY__'
                    command_arr.shift
                  elsif command_arr[0] == '$HN$'
                    @check_command += me + ' '
                    command_arr.shift
                  elsif command_arr[0] == '$FLAG_ON$'
                    @check_command += ''    
                    command_arr.shift
                  elsif command_arr[1] == '$FLAG_ON$'
                    @check_command += command_arr[counter] + ' '
                    command_arr.shift
                  elsif command_arr[0] == '$FLAG_OFF$'
                    @check_command += '' 
                    command_arr.shift
                  elsif command_arr[1] == '$FLAG_OFF$'
                    @check_command += ''
                    command_arr.shift
                  
                  elsif command_arr[0] == ''
                    if command_arr.size > 1
                      if command_arr[1] == ''
                        command_arr.shift
                      else
                        if command_arr[1] == '$HN$'
                          @check_command += me + ' '
                          command_arr.shift
                          command_arr.shift
                        else
                          @check_command += command_arr[1] + ' '
                          command_arr.shift
                          command_arr.shift
                        end    
                      end
                    else
                      command_arr.shift
                    end
        
                  else
                    if command_arr.size > 2
                      if command_arr[0] == '$HN$'
                        @check_command += me + ' '
                        command_arr.shift
                      elsif command_arr[1] == '' 
                        command_arr.shift   
                      elsif command_arr[2] == '__END_OF_COMMAND_ARRAY__'
                        @check_command += command_arr[0] + ' ' + command_arr[1] + ' '
                        command_arr.shift
                      else
                        @check_command += command_arr[0] + ' '
                        command_arr.shift
                      end
          
                    end
                    if command_arr[0] == '$HN$'
                      @check_command += me + ' '
                      command_arr.shift
                    elsif command_arr[1] == ''
                      command_arr.shift
                    elsif command_arr[1] == '__END_OF_COMMAND_ARRAY__'
                      command_arr.shift  
                    else
                      @check_command += command_arr[0] + ' '
                      command_arr.shift
                    end
                  end
                end
                
                @json += '"command": "' + @check_command + '",' + "\n"
                if b.service_check.autofix == nil
                  @json += '"autofix": "None"' + "\n"
                else
                  @json += '"autofix": "' + b.service_check.autofix + '",' + "\n"
                end
              #    "preprocess": "yes/no [NEEDS_TO_BE_COMPLETED]"<br/>
                if chk_element < checks_to_do-1
                  @json += '},{' + "\n"
                else
                  chk_element = chk_element + 1   
                  @json += '}' + "\n"
                end
                chk_element = chk_element + 1  
              end      
            end
            if num_hosts > 1
              if arr_element < num_hosts
                if no_checks == 0
                  @json += ']},{' + "\n"
                else
                  @json += ']},' + "\n"
                end            
              else
                if no_checks == 0
                  @json += ']' + "\n"              
                else
                  @json += ']' + "\n"              
                end
              end
            else
              if num_containers_processed < @service_container.length
                @json += ']},' + "\n"             
              else
                @json += ']' + "\n"             
              end
            end
            arr_element = arr_element + 1
          end  
        end 
        @json += '}]'
      else
        @json += 'Error: No populated containers found for this host.' + "\n"
      end
    end

    respond_to do |format|
      format.html { render :partial => 'build_client_containers', :layout => false, :object => [@json] }
      format.xml  { head :ok }
    end        
  end

  def build_autoformat_client_containers
    # Store the outputted objects into this object.
    # This is the object that will have all the config info
    output_obj = Array.new
    
    # Store checks into this object
    service_checks = Array.new
    
    # Get the hostname from the :host param in the URL
    hosts = params[:host]
    num_hosts = hosts.to_a.length
    # Create an object which has the contents of hostgroups => hosts
    nagios_host_groups = NagiosHostGroup.find(:all, :order => "name")
    all_hosts = {}
    
    # Create the assets object and fill it with all the hosts that belongs to hostgroups with containers that have checks
    nagios_host_groups.each do |a|
      assets = []
      assets << find_nagios_match(a,"")
      assets.each do |b|
        b.each do |c|      
          nagios_host_group = a.id
          service_container = ServiceContainerDetail.find_all_by_nagios_host_group_id(nagios_host_group)
          if service_container.length > 0
            (all_hosts[a.id] ||= []) << c.name
          end
        end
      end
    end      

    #This should output hand-made JSON code
    arr_element = 1
    
    hosts.each do |me|
      done = 0
      all_hosts.each do |a, b|
        # This loop has access to the hosts within each inner array. Refer to them with c
        b.each do |c|
          if c == me and done == 0
            # Once there's a match of hostname within hostgroup, get the hostgroup id.           
            @nagios_host_group = a
            done = 1
          end
        end
      end     
      service_container = ServiceContainerDetail.find_all_by_nagios_host_group_id(@nagios_host_group)
      # Determine which containers have checks, and get rid of the ones that don't.
      service_container.each do |a|
        service_check = ServiceCheckDetail.find(:all, :conditions => ["service_container_id = '#{a.service_container_id}'"])          
        if service_check.length == 0
          #puts a.inspect
          service_container.delete(a)
        end
      end
      if service_container.length > 0 
        num_containers_processed = 0
        service_container.each do |a|
          num_containers_processed += 1
          service_container = ServiceContainer.find(:first, :conditions => ["id = '#{a.service_container_id}'"])
          service_check = ServiceCheckDetail.find(:all, :conditions => ["service_container_id = '#{a.service_container_id}'"])
          service_checks = []
          if service_check.length > 0            
            chk_element = 0
            checks_to_do = 0
            service_check.each do |b|
              service_checker = ServiceChecker.find(:first, :conditions => ["id = '#{b.service_check.service_checker_id}'"])
              if service_checker.checker_type == 0
                checks_to_do = checks_to_do + 1
              end
            end 
            service_check.each do |b|
              service_checker = ServiceChecker.find(:first, :conditions => ["id = '#{b.service_check.service_checker_id}'"])
              if service_checker.checker_type == 0
                if b.service_check.parent_id == 2
                  parent = "None"
                else
                  parent = ServiceCheck.find(:first, :conditions => ["id = '#{b.service_check.parent_id}'"]).name
                end
                command_arr = b.service_check.definition.split('!')
                command_arr.push("__END_OF_COMMAND_ARRAY__")
                d = command_arr.length
                counter = 0
                s = ServiceChecker.find(:first, :conditions => ["id = '#{b.service_check.service_checker_id}'"])
                check_command = s.home + '/' + s.command + ' '
                
                while command_arr.size > 0
                #puts command_arr.inspect
                #puts command_arr[0].inspect
                #puts check_command.inspect
                  #puts check_command.inspect
                  if command_arr[0] == '__END_OF_COMMAND_ARRAY__'
                    command_arr.shift
                  elsif command_arr[0] == '$HN$'
                    check_command += me + ' '
                    command_arr.shift
                  elsif command_arr[0] == '$FLAG_ON$'
                    check_command += ''    
                    command_arr.shift
                  elsif command_arr[1] == '$FLAG_ON$'
                    check_command += command_arr[counter] + ' '
                    command_arr.shift
                  elsif command_arr[0] == '$FLAG_OFF$'
                    check_command += '' 
                    command_arr.shift
                  elsif command_arr[1] == '$FLAG_OFF$'
                    check_command += ''
                    command_arr.shift
                  
                  elsif command_arr[0] == ''
                    if command_arr.size > 1
                      if command_arr[1] == ''
                        command_arr.shift
                      else
                        if command_arr[1] == '$HN$'
                          check_command += me + ' '
                          command_arr.shift
                          command_arr.shift
                        else
                          check_command += command_arr[1] + ' '
                          command_arr.shift
                          command_arr.shift
                        end    
                      end
                    else
                      command_arr.shift
                    end
        
                  else
                    if command_arr.size > 2
                      if command_arr[0] == '$HN$'
                        check_command += me + ' '
                        command_arr.shift
                      elsif command_arr[1] == '' 
                        command_arr.shift   
                      elsif command_arr[2] == '__END_OF_COMMAND_ARRAY__'
                        check_command += command_arr[0] + ' ' + command_arr[1] + ' '
                        command_arr.shift
                      else
                        check_command += command_arr[0] + ' '
                        command_arr.shift
                      end
          
                    end
                    if command_arr[0] == '$HN$'
                      check_command += me + ' '
                      command_arr.shift
                    elsif command_arr[1] == ''
                      command_arr.shift
                    elsif command_arr[1] == '__END_OF_COMMAND_ARRAY__'
                      command_arr.shift  
                    else
                      check_command += command_arr[0] + ' '
                      command_arr.shift
                    end
                  end
                end
                
                if b.service_check.autofix == nil
                  autofix = "None"
                else
                  autofix = b.service_check.autofix
                end
              #    "preprocess": "yes/no [NEEDS_TO_BE_COMPLETED]"<br/>
                service_checks.push({"parent"=>parent, "name"=>b.service_check.name, "frequency"=>b.service_check.frequency.to_s, "autofix"=>autofix, "command"=>check_command})
                #output_obj.push({"name"=>service_container.name, "target_hostname"=>me, "frequency"=>service_container.frequency.to_s, "checks"=>service_checks})
                
                if chk_element >= checks_to_do-1
                  chk_element = chk_element + 1   
                end
                chk_element = chk_element + 1  
              end      
            end
            arr_element = arr_element + 1
            output_obj.push({"name"=>service_container.name, "target_hostname"=>me, "frequency"=>service_container.frequency.to_s, "checks"=>service_checks})
          end  
        end 
      else
        output_obj.push({"Error"=>"No populated containers found for this host."})
      end
    end

    respond_to do |format|
      #format.html { render :partial => 'build_autoformat_client_containers', :layout => false, :object => [output_obj] }
      #format.xml  { head :ok }
      format.html { render :text => "Error: This format is not currently supported. To use html format: http://[AST_SERVER]/service_containers/build_client_containers/[HOSTNAME]"}
      format.xml { render :xml => output_obj.to_xml }
      format.json { render :json => output_obj.to_json }
    end        
  end

  def sort_by_relationship(z)
    par_arr=[] # Store all parent-level checks
    check_arr=[] # Pass this to the external code
    for service in z.sort{|a,b| a.name <=> b.name} 
      # Get all the parents. Checks are either parents or belong to some parent.
      if service.parent_id == 2
        par_arr << service
        z.delete(service)
      end
    end
    #puts par_arr.inspect
    # At this point, z has no parent-level checks. All checks left have a real parent.
    par_arr.each do |y|
      check_arr << y
      l = 1
      z.each do |a|       
        if a.parent_id == y.id
          a.name = l.to_s + "-> " + a.name
          check_arr << a
          # Call the recursive function through all checks
          aa = get_direct_children(a,z,l)
          check_arr += aa
        end
      end
    end 
    return check_arr
  end 
  
  def get_direct_children(o,p,l)
    check_arr=[]
    cur_parent = o.id
    l += 1
    for child in p.sort{|a,b| a.name <=> b.name}
      spacer = ""
      if child.parent_id != 2 and child.parent_id == cur_parent
        t = 1
        while t < l
          spacer += "--"
          t += 1
        end
        spacer += "> "
        child.name = l.to_s + spacer + child.name
        check_arr << child
        # Call self recursively to go through all possible levels of checks
        aa = get_direct_children(child,p,l)
        check_arr += aa
      end
    end
    return check_arr
  end 
end
