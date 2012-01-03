ActionController::Routing::Routes.draw do |map|
  map.home "/", :controller => "home", :action => "index"
  map.root :controller => "home"  
  map.resource :account, :controller => "users", :action => "show"      
		map.autocomplete_game 'games/autocomplete_game_search/:q', :controller => "games", :action => "autocomplete_game_search"		
		map.add_game 'games/add_game', :controller => "games", :action => "add_game"
		map.find_game 'games/find_game/:search_tag/:home_search/:page', :controller => "games", :action => "find_game"  
  map.find_game 'games/find_game/:search_tag/:page', :controller => "games", :action => "find_game"
  map.find_game 'games/find_game/:search_tag', :controller => "games", :action => "find_game"
  map.find_game 'games/find_game/', :controller => "games", :action => "find_game"  		
  map.new_game 'games/new_game', :controller => "games", :action => "new_game"
		map.game_list 'game_list/:user', :controller => "game_list", :action => "index"
  map.game_list 'gamelist/:user', :controller => "game_list", :action => "index"
  map.game_list 'games/:user', :controller => "game_list", :action => "index"
  map.game_list 'games/', :controller =>"game_list", :action => "index"  		
  map.site_facts '/site_facts', :controller => "site_facts", :action => "site_facts"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action', :controller => "home", :action => "index"
end
