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
class SearchController < ApplicationController
  # Disable cookie protection for everything except couple function
  protect_from_forgery :only => [:create, :update, :destroy]

    # Search
  def search
    if ! params[:search][:search].empty?

      # Move acts_as_solr's query parsing out here so plugin doesn't mock with input
      s = params[:search][:search].gsub(/ *: */,"_t:")
      
      # options for solr
      options = {}
      
      # Including each model we have acts_as_solr turned on
      options[:models] = [Server,Pdu,Network,Storage,Vip,Interface,DiskDetail]
      
      # If this is ajax call, limit the result to 5 items
      if request.xhr?
        options[:limit] = 5
      else
        options[:limit] = 1000
      end

      # we want to capture exception but don't care if search didn't yield anything
      begin 
        @results = Asset.multi_solr_search(s,options)

      rescue 
        
      end
    end

    # If request is ajax, then do partial template without loading layout.
    if request.xhr?
      render :partial => "search", :layout => false
    else
      respond_to do |format|
        # If result is just single item, we go into edit view right away
        if @results and @results.records.length == 1
          # If it's an asset, polymorphic the resource directly, if not, we must have found something related to asset
          if @results.records[0].kind_of? Asset
            format.html {  redirect_to(edit_polymorphic_url(@results.records[0].resource)) }
          else
            format.html {  redirect_to(edit_polymorphic_url(@results.records[0].asset.resource)) }
          end
          
        else
          format.html {  }
          format.xml  { head :ok }
        end
      end
    end    
  end
  
end
