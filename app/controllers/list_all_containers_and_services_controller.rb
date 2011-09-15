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
class ListAllContainersAndServicesController < ApplicationController
  require 'networking'

  def index
    
    my_list = {}
    
    # This will simply return a sorted list of all the containers.
    containers = []
    @service_containers = ServiceContainer.find(:all, :order => "name")
    for service_container in @service_containers
      containers << service_container.name
    end
    
    # This will simply return a sorted list of all nagios service checks.
    services = []
    @nagios_services = NagiosService.find(:all, :order => "name")
    for nagios_service in @nagios_services
      services << nagios_service.name
    end
    
    my_list['passive'] = containers
    my_list['active'] = services
    @o = my_list.to_json
    render(:partial => "output",:object => @o)
    
  end
end
