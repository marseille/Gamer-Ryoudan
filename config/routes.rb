ActionController::Routing::Routes.draw do |map|
  map.home "/", :controller => "home", :action => "index"
  map.root :controller => "home"  
  map.resource :account, :controller => "users", :action => "show"  
  map.game_list 'game_list/:user', :controller => "game_list", :action => "index"
  map.find_game 'games/find_game/:search_tag', :controller => "games", :action => "find_game"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
