require 'test_helper'
require "authlogic/test_case"

class GamesControllerTest < ActionController::TestCase  
  
  setup :activate_authlogic	
  
  test "add_game should make an addition request to the administrator" do    
    u = User.create({"login" => "login1", "password"=>"123456", "password_confirmation"=>"123456", "email" => "1@1.aol.com"})				    
    num_deliveries = ActionMailer::Base.deliveries.size		
    post :add_game, {"game" => {"name"=>"g1", "platform"=>"p1"}}
    assert_not_nil assigns["current_user"]    
    assert_equal @response.body, "Your request has been submitted! Thank you for making the Gamer Ryoudan better.".to_json        
    
    assert_equal num_deliveries+1, ActionMailer::Base.deliveries.size		
  end

  test "add_game should make an addition request and note an addition to the user's game list" do
    u = User.create({"login" => "login1", "password"=>"123456", "password_confirmation"=>"123456", "email" => "1@1.aol.com"})				    
    num_deliveries = ActionMailer::Base.deliveries.size		
    post :add_game, {"game" => {"name"=>"g1", "platform"=>"p1"}, 
                                "add_to_list"=>true,
                                "game_information"=>{"user_id"=>u["id"]}}
    assert_equal  u["id"].to_s, @request.parameters["game_information"]["user_id"]
    assert_not_nil assigns["current_user"]
    assert_equal @response.body, "Your request has been submitted! Thank you for making the Gamer Ryoudan better.".to_json        
    assert_equal num_deliveries+1, ActionMailer::Base.deliveries.size		
  end
  
  test "add_game should not make a request when the requested game already exists" do
    u = User.create({"login" => "login1", "password"=>"123456", "password_confirmation"=>"123456", "email" => "1@1.aol.com"})				    
    g = Game.create({"name" => "g", "platform" => "p"})
    post :add_game, {"game" => {"name" => "g", "platform" => "p"}}
    assert_equal @response.body, "That game already exists".to_json
  end
  
  test "autocomplete_game_search should return results from a game-name search query made AJAX style" do
    games = []
    games.push(Game.create({"name" => "g", "platform" => "p"}))
    games.push(Game.create({"name" => "g1", "platform" => "p1"}))
    games.push(Game.create({"name" => "g2", "platform" => "p2"}))
    games.push(Game.create({"name" => "g3", "platform" => "p3"}))
    get :autocomplete_game_search, {"q" => "g"}
    results =  (games.flatten.collect {|game| [game["name"] + " ["+game["platform"]+"]", game["platform"]]}).to_json    
    assert_equal results, @response.body
  end

  test "autocomplete_game_search should return results from a platform-name search query made AJAX style" do
    games = []
    games.push(Game.create({"name" => "g", "platform" => "p"}))
    games.push(Game.create({"name" => "g1", "platform" => "p1"}))
    games.push(Game.create({"name" => "g2", "platform" => "p2"}))
    games.push(Game.create({"name" => "g3", "platform" => "p3"}))
    get :autocomplete_game_search, {"q" => "p"}    
    results =  (games.flatten.collect {|game| [game["name"] + " ["+game["platform"]+"]", game["platform"]]}).to_json        
    assert_equal @response.body, results
    
    get :autocomplete_game_search, {"q" => "p1"}    
    results = [["g1 [p1]", "p1"]]
    assert_equal @response.body, results.to_json
        
    games.push(Game.create({"name" => "great game p1", "platform"=>"p1"}))    
    games.push(Game.create({"name" => "great gamenumber2 p1", "platform"=>"p2"}))    
        
    get :autocomplete_game_search, {"q" => "p1"}    
    results = [["great game p1 [p1]", "p1"], 
                    ["great gamenumber2 p1 [p2]", "p2"],
                    ["g1 [p1]", "p1"]]
    assert_equal results.to_json, @response.body
  end
end