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
class ColosController < ApplicationController
  # GET /colos
  # GET /colos.xml
  def index
    @colos = Colo.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @colos }
    end
  end

  # GET /colos/1
  # GET /colos/1.xml
  def show
    @colo = Colo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @colo }
    end
  end

  # GET /colos/new
  # GET /colos/new.xml
  def new
    @colo = Colo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @colo }
    end
  end

  # GET /colos/1/edit
  def edit
    @colo = Colo.find(params[:id])
  end

  # POST /colos
  # POST /colos.xml
  def create
    @colo = Colo.new(params[:colo])

    respond_to do |format|
      if @colo.save
        flash[:notice] = 'Colo was successfully created.'
        format.html { redirect_to(@colo) }
        format.xml  { render :xml => @colo, :status => :created, :location => @colo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @colo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /colos/1
  # PUT /colos/1.xml
  def update
    @colo = Colo.find(params[:id])

    respond_to do |format|
      if @colo.update_attributes(params[:colo])
        format.html { render :action => "edit" }
        flash[:notice] = 'Colo was successfully updated.'
        format.html { redirect_to(@colo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @colo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /colos/1
  # DELETE /colos/1.xml
  def destroy
    @colo = Colo.find(params[:id])

    if @colo.assets.length > 0 or @colo.vlan_details.length > 0
      flash[:error] = "#{@colo.name} has assets or vlans assigned, please remove association first." 
    else  
      @colo.destroy
    end

    respond_to do |format|
      format.html { redirect_to(colos_url) }
      format.xml  { head :ok }
    end
  end
  
  # Create map 
  def build_map
    # Output buffer
    @o = '' 
    
    @colo = Colo.find(params[:id])
    
    @rows = {}
    # Loop through colo
    @colo.assets.each { |a| 
      if !a.row.nil? and !a.rack.nil? and !a.pos.nil?
        #@o += a.name + "<br/>"
        
        # Initialize each array
        if @rows[a.row.capitalize].nil?
          @rows[a.row.capitalize] = Array.new
        end
        
        if @rows[a.row.capitalize][a.rack].nil?
          @rows[a.row.capitalize][a.rack] = Array.new
        end
        # Then add the element into that particular rack
        # We find out how many U an asset is, 
        # if more than 1 then also put asset on those position it takes up 
        begin
          if not a.resource.respond_to?('unit') or a.resource.unit.nil? or a.resource.unit <= 1
            if @rows[a.row.capitalize][a.rack][a.pos].nil?
              @rows[a.row.capitalize][a.rack][a.pos] = Array.new
            end
            @rows[a.row.capitalize][a.rack][a.pos] << a
          else
            (0..a.resource.unit-1).each do |i|
              if @rows[a.row.capitalize][a.rack][a.pos + i].nil?
                @rows[a.row.capitalize][a.rack][a.pos + i] = Array.new
              end
              @rows[a.row.capitalize][a.rack][a.pos + i] << a  
            end
          end         
        rescue Exception => exc
          p a.inspect
        end
        
        
      end
      
    
    }
    
    
    # Sort the info  
    @rows = @rows.sort
    
    # Base height for table cell so the look across the row is aligned.
    @base_height = 28
  end
end
