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
class ServiceChecksController < ApplicationController
  # GET /service_checks
  # GET /service_checks.xml
  helper_method :build_check_command, :sort_by_relationship
  def index
    @service_checks = ServiceCheck.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @service_checks }
    end
  end

  # GET /service_checks/1
  # GET /service_checks/1.xml
  def show
    @service_check = ServiceCheck.find(params[:id])
    #puts @service_check.to_json(:except => [:id, :created_at, :updated_at])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service_check }
    end
  end

  # GET /service_checks/new
  # GET /service_checks/new.xml
  def new
    @service_check = ServiceCheck.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service_check }
    end
  end

  # GET /service_checks/1/edit
  def edit
    @service_check = ServiceCheck.find(params[:id])
  end

  # POST /service_checks
  # POST /service_checks.xml
  def create
    @service_check = ServiceCheck.new(params[:service_check])

    respond_to do |format|
      if @service_check.save
        flash[:notice] = 'ServiceCheck was successfully created.'
        format.html { redirect_to(@service_check) }
        format.xml  { render :xml => @service_check, :status => :created, :location => @service_check }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service_check.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /service_checks/1
  # PUT /service_checks/1.xml
  def update
    @service_check = ServiceCheck.find(params[:id])

    respond_to do |format|
      if @service_check.update_attributes(params[:service_check])
        flash[:notice] = 'ServiceCheck was successfully updated.'
        format.html { redirect_to(@service_check) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service_check.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /service_checks/1
  # DELETE /service_checks/1.xml
  def destroy
    @service_check = ServiceCheck.find(params[:id])
    @service_check.destroy

    respond_to do |format|
      format.html { redirect_to(service_checks_url) }
      format.xml  { head :ok }
    end
  end
 
  # Link interface for hostgroup
  def create_detail
    @service_container = ServiceContainer.find(params[:id])
    
    # Create service check for each selected one
    for service_check in params[:service_checks][:service_check_id]
      if ! service_check.empty?
        service_detail = ServiceCheckDetail.find_or_create_by_service_container_id_and_service_check_id(params[:id],service_check)
      end
      create_recursive_detail(service_check)
      
    end
    flash[:service_check] = "Service check(s) added"

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @service_container }
      format.xml  { head :ok }
    end    
    
  end
  
  def create_recursive_detail(s)
    #s is the id of the service_check passed into it
    @s = ServiceCheck.find(s)
    if @s.parent_id != 2
      service_detail = ServiceCheckDetail.find_or_create_by_service_container_id_and_service_check_id(params[:id],@s.parent_id)
      create_recursive_detail(@s.parent_id)
    end
  end

  # Destroy service and escalation
  def destroy_detail
    service_detail = ServiceCheckDetail.find(params[:id])
    
    @service_container = service_detail.service_container
    service_check = service_detail.service_check
    
    # Destroy service itself
    service_detail.destroy
    # Then delete any descendants
    delete_all_descendants(service_check.id,@service_container.id)
    

    flash[:service_check] = "Service check(s) deleted."

    respond_to do |format|
      format.html { render :partial => 'mini_edit', :layout => false, :object => @service_container }
      format.xml  { head :ok }
    end     
  end

  def delete_all_descendants(s,c)
    # s = service check id, c = container id
    #puts "herro"
    # Find all checks in this container
    @checks = ServiceCheckDetail.find_all_by_service_container_id(c)
    for a in @checks
      check = ServiceCheck.find(a.service_check_id)
      # If check's parent = me, then delete
      if check.parent_id != 2 and check.parent_id == s
        a.destroy
        # Recurse it.
        delete_all_descendants(a.service_check_id,c)
      end
    end
  end
  
  def update_service_checker
    @service_check = ServiceCheck.find(params[:id])
  
    #Assign a variable to hold the value of the first item of the array. Selection box is an array.   
    key = params[:service_checkers][:service_checker_id][0]

    #Create a new array
    v = {}
    #Create a key of the database field name with the value desired
    v[:service_checker_id] = key
    
    respond_to do |format|
      if @service_check.update_attributes(v)
        format.html { render(:update){ |page| page.call 'location.reload' }}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service_check.errors, :status => :unprocessable_entity }
      end
    end
  end
 
  def update_service_check_parent
    @service_check = ServiceCheck.find(params[:id])
  
    #Assign a variable to hold the value of the first item of the array. Selection box is an array.   
    key = params[:service_checks][:parent_id][0]

    #Create a new array
    v = {}
    #Create a key of the database field name with the value desired
    v[:parent_id] = key
    
    # Check if the parent's parent (or any of the parents' parents...) are this check, and error out if so
    parent_done = 0
    bad_parent = 0
    target = v[:parent_id]
    while (parent_done == 0)
      @validator = ServiceCheck.find(target)
      if @validator.parent_id != 2
        if @validator.parent_id == @service_check.id
          bad_parent = 1
          parent_done = 1
        else
          target = @validator.parent_id
        end
      else
        parent_done = 1
      end
    end
    respond_to do |format|
      if bad_parent == 1
        flash[:notice] = 'Unable to update ServiceCheckParent. A circular parent-child relationship would be created!'
        format.html { render(:update){ |page| page.call 'location.reload' }}
        format.xml  { render :xml => @service_check.errors, :status => :unprocessable_entity }      
      else
        if @service_check.update_attributes(v)
          flash[:notice] = 'ServiceCheckParent was successfully updated.'
          format.html { render(:update){ |page| page.call 'location.reload' }}
          #format.html { render :action => "_create_dynamic_fields", :layout => false}
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @service_check.errors, :status => :unprocessable_entity }
        end
      end
    end
  end 
  
  def create_dynamic_fields
    @service_check = ServiceCheck.find(params[:id])
    @service_check[:observed_field] = params[:watched]
   
    respond_to do |format|
        format.html { render :action => "_create_dynamic_fields", :layout => false, :object => @service_check }
        format.xml  { head :ok }
    end
  end
  
  def implode_definition
    @service_check = ServiceCheck.find(params[:id])
    @service_checker = ServiceChecker.find(@service_check.service_checker_id)
    checker_arr=@service_checker.definition.split('!')
    raw_def_array = params[:def_arr]
    raw_def_array_length = raw_def_array.length
    # If the input array exists, load it, and add one arg to the var because we always want a minimum of two args in the array.
    if params[:input_arr]
      input_arr = params[:input_arr]
      #input_arr << ''      
    end
    # If the validation array exists, load it
    if params[:validation_arr]
      validation_arr = params[:validation_arr]
    end    

    valid_input = 0    
    counter = 0
    counter2 = 0
    input_counter = 0
    def_array = []
    error_str = ''    
    # The arguments in the raw_def_array are related to the arguments in checker_arr by this formula:
    # checker_arr_index = ( raw_def_array_index * 2 ) + ( raw_def_array_index / 2 )
    # except in the case where a flag is turned on, because that increases the flag's block from a size of 2 to 3
    # Seriously. Uncomment the following 2 puts lines to see for yourself, and do the math.
    # puts checker_arr.inspect
    # puts raw_def_array.inspect
    # Check that all required fields are populated. If not, then increment valid_input to indicate an error.
    # In the checker_arr, the index after the arg's index == $REQ$ if required.
    # Therefore, the index to check is ( raw_def_array_index * 2 ) + (raw_def_array_index / 2 ) + 1
    while counter < raw_def_array_length
      case raw_def_array[counter]
        when 'on'
         # Add $FLAG_ON$ to the array, skip the next element
          def_array << '$FLAG_ON$'
          counter = counter + 1 
        when '$FLAG$'
          if raw_def_array[counter - 1] == 'on'
            # Decrement counter2 to keep the checker_arr's index counter correct
            counter2 -= 1
          else
            if checker_arr[((counter2-1) * 2) + ((counter2-1) / 2) + 1] == '$REQ$'
              valid_input += 1
              error_str += ' ' + '(Required & Missing)' + raw_def_array[counter-1]
            end
            #Add $FLAG_OFF$ to the array
            def_array << '$FLAG_OFF$'
          end
        when '$ARG$'
          if input_arr[input_counter] != ''
            def_array << '$ARG_ON$'
          else
            if checker_arr[((counter2-1) * 2) + ((counter2-1) / 2) + 1] == '$REQ$'
              valid_input += 1
              error_str += ' ' + '(Required & Missing)' + raw_def_array[counter-1]
            end
            def_array << '$ARG_OFF$'
          end  
          input_counter += 1
        when ''
          # Do nothing.
          #puts 'this space intentionally left blank'
          def_array << raw_def_array[counter]
        else
          # Add all other values to the array
          def_array << raw_def_array[counter]
        end
      counter  += 1
      counter2 += 1
    end
    #puts def_array.inspect
    #puts raw_def_array.inspect
    definition = ''
    spacer = '!'
    def_pair_length = def_array.length
    # Checkboxes look towards def_arr. Everything else looks towards input_arr for its user-defined values, so use a different counter.
    input_arr_counter = 0

    # This steps through the definition and converts it into a command. Use length - 1 because each pair of args is a unit.
    0.upto(def_pair_length-1) {|n|
      # If the 2nd arg is a checkbox, then set the value in the command to nothing, else use the saved value.
      if def_array[n+1] == '$FLAG_OFF$'
        value = def_array[n] + spacer + '$FLAG_OFF$'
      elsif def_array[n+1] == '$FLAG_ON$'
        value = def_array[n] + spacer + '$FLAG_ON$'
      elsif def_array[n+1] == '$ARG_ON$'
        # Validate that the value is acceptable
        # The index for the validation is n/2 because that rounds off to an integer, and the validation array
        # is half as long as the definition array.

        # Check if it's an integer. For now, it accepts negative integers too.
        if validation_arr[n/2] == '$NUMERIC$'
          if input_arr[input_arr_counter].match(/^(\-|\+)?\d+$/) 
            valid_input += 0
          else
            valid_input += 1
            error_str += ' ' + '(Failed Validation)' + def_array[n]
          end
        # Check if it's a string. Probably everything is a string.
        elsif validation_arr[n/2] == '$TEXT$'          
          if input_arr[input_arr_counter].is_a?(String)
            valid_input += 0
          else
            valid_input += 1
          end
        end
        value = def_array[n] + spacer + input_arr[input_arr_counter]
        input_arr_counter = input_arr_counter + 1
      elsif def_array[n+1] == '$ARG_OFF$'
        #value = ''        
        value = def_array[n] + "!"
        input_arr_counter = input_arr_counter + 1
      elsif def_array[n] == '$FLAG_ON$'
        value = ''
      elsif def_array[n] == '$FLAG_OFF$'
        value = ''
      elsif def_array[n] == '$ARG_ON$'
        value = ''
      elsif def_array[n] == '$ARG_OFF$'
        value = ''
      elsif def_array[n] == '$NONE$'
        value = ''
      end
      if definition == ''
        definition = value
      else
        if value != ''
          definition = definition + spacer + value
        end                
      end
    }
    # Build the check command
    respond_to do |format|
      flash[:error] = nil
      if valid_input == 0
        @service_check.update_attribute(:definition, definition)
        @check_command = build_check_command(@service_check)
        flash[:notice] = 'ServiceCheckDefinition was successfully updated.'
        format.html { render :action => "_implode_definition", :layout => false, :object => [@service_check, @check_command] }
        format.xml  { head :ok }    
      else
        flash[:error] = 'The following fields had improper data: ' + error_str
        format.html { render :action => "_implode_definition", :layout => false, :object => [@service_check, @check_command, definition] }
        format.xml  { render :xml => @service_check.errors, :layout => false, :status => :unprocessable_entity }
      end
    end    
  end
  
  def build_check_command(service_check)
    x = ServiceCheck.find(:first, :conditions => ["id = '#{service_check.id}'"]).definition
    command_arr = x.split('!')
    command_arr.push("__END_OF_COMMAND_ARRAY__")
    c = command_arr.length
    counter = 0
    s = ServiceChecker.find(:first, :conditions => ["id = '#{service_check.service_checker_id}'"])
    @check_command = s.home + '/' + s.command + ' '
    #while counter < c
    #  if command_arr[counter] == '$FLAG_ON$'
    #    @check_command += ''      
    #  elsif command_arr[counter + 1] == '$FLAG_ON$'
    #    @check_command += command_arr[counter] + ' '
    #  elsif command_arr[counter] == '$FLAG_OFF$'
    #    @check_command += ''        
    #  elsif command_arr[counter + 1] == '$FLAG_OFF$'
    #    @check_command += ''
    #  elsif command_arr[counter + 1] == ''# or command_arr[counter + 1] == nil
    #    @check_command += ''
    #  else
    #    @check_command += command_arr[counter] + ' '
    #  end
    while command_arr.size > 0
      #puts command_arr.size.inspect
      #puts command_arr.inspect
      if command_arr[0] == '__END_OF_COMMAND_ARRAY__'
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
            @check_command += command_arr[1] + ' '
            command_arr.shift
            command_arr.shift
          end
        else
          command_arr.shift
        end
        
      else
        if command_arr.size > 2
          if command_arr[1] == ''  
            command_arr.shift 
          elsif command_arr[2] == '__END_OF_COMMAND_ARRAY__'
            @check_command += command_arr[0] + ' ' + command_arr[1] + ' '
            command_arr.shift
          else
            @check_command += command_arr[0] + ' '
            command_arr.shift
          end
          
        end
        if command_arr[1] == ''
          command_arr.shift
        elsif command_arr[1] == '__END_OF_COMMAND_ARRAY__'
          command_arr.shift
        else
          @check_command += command_arr[0] + ' '
          command_arr.shift
        end
      end

     #counter = counter + 1 
   end
   return @check_command
 end
 
  def sort_by_relationship(z)
    par_arr=[] # Store all parent-level checks
    check_arr=[] # Pass this to the external code
    for service in z.sort{|a,b| a.name <=> b.name} 
      # Get all the parents. Checks are either parents or belong to some parent.
      if service.parent_id == 2
        z.delete(service)
        par_arr << service
      end
    end
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
  
  def delete_check
    # If this check has any children, set them to my parent  
    @service_check = ServiceCheck.find(params[:id])
    my_parent = @service_check.parent_id
    my_id = params[:id]
    @child_checks = ServiceCheck.find_all_by_parent_id(my_id)
    @child_checks.each do |a|
      a.update_attribute(:parent_id, my_parent)
    end
    @service_check.destroy
    respond_to do |format|
      format.html { redirect_to(service_checks_url) }
      format.xml  { head :ok }
    end
  end
end
