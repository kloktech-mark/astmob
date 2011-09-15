ActionController::Routing::Routes.draw do |map|

  map.connect 'pxe/:colo', 
    :controller => 'pxe', 
    :action => 'fetch_colo',
    :src => /.*/

  # Special connector for fetch zone, define src to include everything and skip the ID thing
  map.connect 'dns_zones/fetch_zone/:src/:type', 
    :controller => 'dns_zones', 
    :action => 'fetch_zone',
    :src => /.*/
    
  map.connect 'service_containers/build_client_containers/:host', 
    :controller => 'service_containers', 
    :action => 'build_client_containers',
    :host => /.*/  
    
  map.connect 'service_containers/build_autoformat_client_containers/:host.:format', 
    :controller => 'service_containers', 
    :action => 'build_autoformat_client_containers',
    :host => /.*/  
  
  map.connect 'dns_cnames/check_cnames/:host', 
    :controller => 'dns_cnames', 
    :action => 'check_cnames',
    :host => /.*/  

  map.resources :audits
    
  map.resources :dns_cnames
  
  map.resources :dns_zones
  
  map.resources :dns
  
  map.resources :nagios_service_group_details

  map.resources :nagios_service_groups

  map.resources :nagios_host_templates

  map.resources :nagios_contact_group_service_escalation_details

  map.resources :nagios_contact_groups

  map.resources :nagios_service_escalations

  map.resources :nagios_service_escalation_templates

  map.resources :nagios_service_templates

  map.resources :nagios_service_details

  map.resources :nagios_services

  map.resources :nagios_host_groups
  
  map.resources :service_check_details  
  
  map.resources :service_containers
  
  map.resources :service_container_details
  
  map.resources :service_checkers
  
  map.resources :service_checks

  map.resources :mass_import
  
  map.resources :mass_ocs_update
  
  map.resources :list_all_containers_and_services
  
  map.resources :search
  
  map.resources :vlan_details

  map.resources :vlans

  map.resources :states

  map.resources :server_models

  map.resources :network_models

  map.resources :networks

  map.resources :vip_servers
  
  map.resources :vips

  map.resources :storages
  
  map.resources :disk_models

  map.resources :disk_details

  map.resources :pdu_models

  map.resources :pdus

  map.resources :servers

  map.resources :colos

  map.resources :assets
  
  map.resources :cpu_models
  
  map.resources :cpu_details

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action
  
  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "assets"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
