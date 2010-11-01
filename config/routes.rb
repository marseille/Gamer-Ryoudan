ActionController::Routing::Routes.draw do |map|
  map.home "/", :controller => "home", :action => "index"
  map.root :controller => "home"  
  map.resource :account, :controller => "users", :action => "show"  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
