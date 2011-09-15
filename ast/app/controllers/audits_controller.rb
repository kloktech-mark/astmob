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
class AuditsController < ApplicationController
  
  def index
    @audits = Audit.paginate :page => params[:page], :per_page => 15, :order => 'created_at DESC'
    #@audits = Audit.find(:all, :limit => 30, :order => 'created_at DESC') 
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @servers }
    end    
  end
end
