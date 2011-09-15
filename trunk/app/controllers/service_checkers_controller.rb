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
class ServiceCheckersController < ApplicationController
  # GET /service_checkers
  # GET /service_checkers.xml
  def index
    @service_checkers = ServiceChecker.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @service_checkers }
    end
  end

  # GET /service_checkers/1
  # GET /service_checkers/1.xml
  def show
    @service_checker = ServiceChecker.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service_checker }
    end
  end

  # GET /service_checkers/new
  # GET /service_checkers/new.xml
  def new
    @service_checker = ServiceChecker.new(:strict => "0", :checker_type => "0")

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service_checker }
    end
  end

  # GET /service_checkers/1/edit
  def edit
    @service_checker = ServiceChecker.find(params[:id])
  end

  # POST /service_checkers
  # POST /service_checkers.xml
  def create
    @service_checker = ServiceChecker.new(params[:service_checker])

    respond_to do |format|
      if @service_checker.save
        flash[:notice] = 'ServiceChecker was successfully created.'
        format.html { redirect_to(@service_checker) }
        format.xml  { render :xml => @service_checker, :status => :created, :location => @service_checker }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service_checker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /service_checkers/1
  # PUT /service_checkers/1.xml
  def update
    @service_checker = ServiceChecker.find(params[:id])

    respond_to do |format|
      if @service_checker.update_attributes(params[:service_checker])
        flash[:notice] = 'ServiceChecker was successfully updated.'
        format.html { redirect_to(@service_checker) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service_checker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /service_checkers/1
  # DELETE /service_checkers/1.xml
  def destroy
    @service_checker = ServiceChecker.find(params[:id])
    @service_checker.destroy

    respond_to do |format|
      format.html { redirect_to(service_checkers_url) }
      format.xml  { head :ok }
    end
  end
  
  def build_definition
    @service_checker = ServiceChecker.find(params[:id])
    
    # Assign variables to the form data.
    ident = params[:ident]
    req_cbox = params[:req_cbox]    
    switch_cbox = params[:switch_cbox]
    validation = params[:validation_select]
    long_desc = params[:long_desc]
    key_cbox = params[:key_cbox]
    
    # Create the blob to append to the definition.
    new_arg = ''
    spacer = '!'
    
    new_arg += ident
    
    # if req_cbox == 'on', then the checkbox was checked, so populate a flag of $REQ$, else populate it with a flag of $OPT$
    if req_cbox == 'on'
      new_arg += spacer + '$REQ$'
    else
      new_arg += spacer + '$OPT$'
    end
    
    # if switch_cbox == 'on', then the checkbox was checked, so populate a flag of $FLAG$, else populate it with a flag of $ARG$
    if switch_cbox == 'on'
      new_arg += spacer + '$FLAG$'
    else
      new_arg += spacer + '$ARG$'
    end
    
    # validation defines the type of validation required. Either $NONE$, $NUMERIC$, or $TEXT$
    case validation
      when "none"
        new_arg += spacer + '$NONE$'
      when "numeric"
        new_arg += spacer + '$NUMERIC$'
      when "text"
        new_arg += spacer + '$TEXT$'
    end
    
    # Add the long_desc, but give it a flag if it's blank.
    if long_desc == ''
      long_desc = '$NONE$'
    end
    new_arg += spacer + long_desc
    
    # Add the key
    # if key_cbox == 'on', then the checkbox was checked, so populate a flag of $REQ$, else populate it with a flag of $OPT$
    if key_cbox == 'on'
      new_arg += spacer + '$KEY_YES$'
    else
      new_arg += spacer + '$KEY_NO$'
    end
    
    
    # Get the existing definition from the database.
    old_def = @service_checker.definition
    
    # Append the new blob to the existing definition, update it, then reload the page.
    if old_def == ''
      new_def = new_arg
    else
      new_def = old_def + spacer + new_arg
    end
    
    @service_checker.update_attribute(:definition, new_def)
    respond_to do |format|
      if @service_checker.update_attribute(:definition, new_def)
        flash[:notice] = 'ServiceCheckerDefinition was successfully updated.'
        format.html { render :action => "_build_checker_definition", :layout => false, :object => @service_checker }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service_checker.errors, :status => :unprocessable_entity }
      end      
    end
  end
  
  def del_definition
    @service_checker = ServiceChecker.find(params[:id])    
    @has_checks = has_checks
    if @has_checks == 0  
      blank_def = ''
      @service_checker.update_attribute(:definition, blank_def)
      respond_to do |format|
        if @service_checker.update_attribute(:definition, blank_def)
          format.html { render :action => "edit", :object => @service_checker }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @service_checker.errors, :status => :unprocessable_entity }
        end      
      end
    else
      respond_to do |format|
        flash[:notice] = 'ServiceCheckerDefinition can not be modified since this checker has been assigned to a check already.'
        format.html { render :action => "edit", :object => @service_checker }
        format.xml  { render :xml => @service_checker.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def del_def_arg
    @service_checker = ServiceChecker.find(params[:id])
    @has_checks = has_checks
      if @has_checks == 0
      @pass = params[:pass].to_i
      @def = params[:def]
      # Delete according to the formula pass*6 + (0-5)
      # As each item is deleted, the whole stack scoots up
      0.upto(5) { |n|
        @def.delete_at(@pass*6) 
      }
      new_def = @def.join('!')
      @service_checker.update_attribute(:definition, new_def)
      respond_to do |format|
        if @service_checker.update_attribute(:definition, new_def)
          flash[:notice] = 'ServiceCheckerDefinition was successfully updated.'
          format.html { render :action => "edit", :object => @service_checker }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @service_checker.errors, :status => :unprocessable_entity }
        end      
      end
    else
      respond_to do |format|
        flash[:notice] = 'ServiceCheckerDefinition can not be modified since this checker has been assigned to a check already.'
        format.html { render :action => "edit", :object => @service_checker }
        format.xml  { render :xml => @service_checker.errors, :status => :unprocessable_entity }
      end    
    end
  end
  
  def has_checks
    @service_checker = ServiceChecker.find(params[:id])
   
    @has_checks = ServiceCheck.find_by_service_checker_id(@service_checker)
    if @has_checks != nil
      aa = 1
    else
      aa = 0
    end
    return aa
  end

  def edit_definition
    @service_checker = ServiceChecker.find(params[:id])
    @has_checks = has_checks
    if @has_checks == 0
      raw_def = params[:prev_input_arr]
      new_def = []
      raw_def_length = raw_def.length
   
      # Translate the text into what the schema expects.
      0.upto(raw_def_length-1) { |n|
        if raw_def[n] == "Arg"
          new_def << "$ARG$"
        elsif raw_def[n] == "Flag"
          new_def << "$FLAG$"
        elsif raw_def[n] == "none"
          new_def << "$NONE$"
        elsif raw_def[n] == "numeric"
          new_def << "$NUMERIC$"
        elsif raw_def[n] == "text"
          new_def << "$TEXT$"
        elsif raw_def[n] == "Y"
          if n%6 == 1
            new_def << "$REQ$"
          else
            new_def << "$KEY_YES$"
          end
        elsif raw_def[n] == "N"
          if n%6 == 1
            new_def << "$OPT$"
          else
            new_def << "$KEY_NO$"
          end
        else
          new_def << raw_def[n]
        end
      }
      # Convert the text into a string.
      final_def = new_def.join("!")
      #puts final_def.inspect
      @service_checker.update_attribute(:definition, final_def)
      respond_to do |format|
        flash[:notice] = 'ServiceCheckerDefinition was successfully updated.'
        format.html { render :action => "_build_checker_definition", :layout => false, :object => @service_checker }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        flash[:notice] = 'ServiceCheckerDefinition can not be modified since this checker has been assigned to a check already.'
        format.html { render :action => "_build_checker_definition", :layout => false, :object => @service_checker }
        format.xml  { render :xml => @service_checker.errors, :status => :unprocessable_entity }    
      end
    end
  end
  
  def delete_checker
    @service_checker = ServiceChecker.find(params[:id])
    @has_checks = has_checks
    if @has_checks == 0
      @service_checker.destroy

      respond_to do |format|
        format.html { redirect_to(service_checkers_url) }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        flash[:notice] = 'ServiceChecker can not be deleted since this checker has been assigned to a check already.'
        format.html { redirect_to(service_checkers_url) }
        format.xml  { head :ok } 
      end
    end
  end
end
