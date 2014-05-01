GamerRyoudan::Application.routes.draw do
  resources :users
  
  root  :to => "home#index"
  get "games/autocomplete_game_search/:q", :to => "games#autocomplete_game_search"
  post "games/add_game", :to => "games#add_game"
  get "games/find_game/:search_tag/:home_search/:page", :to => "games#find_game"
  get "games/find_game/:search_tag/:page", :to => "games#find_game"
  get "games/find_game/:search_tag/", :to => "games#find_game"
  get "games/find_game/", :to => "games#find_game"
  get "games/new_game", :to => "games#new_game"
  get "game_list/:user", :to => "game_list#index"
  get "games/:user", :to => "game_list#index"
  get "games/", :to => "game_list#index"
  get "/site_facts", :to => "site_facts#index"
  match "/:controller(/:action(/:id))", via: [:get, :post]
end
