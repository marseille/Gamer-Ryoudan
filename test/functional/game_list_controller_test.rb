require 'test_helper'
require "authlogic/test_case"

class GameListControllerTest < ActionController::TestCase
  
		setup :activate_authlogic	
		
		test 'Redirect to main page with message if user is not specified' do
				get :index				
				assert_response 302				
				assert flash["display_message"]				
				assert_equal @response.instance_variable_get("@redirected_to"), "/"
		end
		
		test "Redirect to the user's gamelist if user is logged in, with url similar to ~.com/game_list/" do
				u = User.create({"login" => "login1", "password"=>"123456", "password_confirmation"=>"123456", "email" => "1@1.aol.com"})				
				get :index								
				assert_response 302								
				assert_equal @response.instance_variable_get("@redirected_to"), "/game_list/login1"								
		end
		
		test "index should identify the user's games and organize them" do				
				u = User.create({"login" => "login1", "password"=>"123456", "password_confirmation"=>"123456", "email" => "1@1.aol.com"})								
				g1 = Game.create({"name"=>"g1", "platform" => "p1"})
				g2 = Game.create({"name"=>"g2", "platform" => "p2"})
				g3 = Game.create({"name"=>"g3", "platform" => "p3"})
				g4 = Game.create({"name"=>"g4", "platform" => "p4"})
				ginfo1 = GameInformation.create({"status" => "Campaigns", "user_id" => u["id"], "game_id" => g1["id"]})
				ginfo2 = GameInformation.create({"status" => "Centrum Contentus", "user_id" => u["id"], "game_id" => g2["id"]})				
				ginfo3 = GameInformation.create({"status" => "Contrived Crusades", "user_id" => u["id"], "game_id" => g3["id"]})				
				ginfo4 = GameInformation.create({"status" => "Conquests", "user_id" => u["id"], "game_id" => g4["id"]})				
				gmap1 = GameInformationMap.create({"game_id" => g1["id"], "user_id" => u["id"]})
				gmap1 = GameInformationMap.create({"game_id" => g2["id"], "user_id" => u["id"]})
				gmap1 = GameInformationMap.create({"game_id" => g3["id"], "user_id" => u["id"]})
				gmap1 = GameInformationMap.create({"game_id" => g4["id"], "user_id" => u["id"]})		
				get :index, {"user" => u["login"]}								
				assert_equal u.games.first, assigns["currently_playing"].first.first
				assert_equal u.games[1], assigns["hiatus"].first.first
				assert_equal u.games[2], assigns["planned"].first.first
				assert_equal u.games[3], assigns["completed"].first.first
				assert_equal "Campaigns", assigns["currently_playing"].first[1]["status"]				
				assert_equal "Centrum Contentus", assigns["hiatus"].first[1]["status"]
				assert_equal "Contrived Crusades", assigns["planned"].first[1]["status"]
				assert_equal "Conquests", assigns["completed"].first[1]["status"]
				assert_equal [[g1,ginfo1]], assigns["currently_playing"]
				assert_equal [[g2,ginfo2]], assigns["hiatus"]
				assert_equal [[g3,ginfo3]], assigns["planned"]
				assert_equal [[g4, ginfo4]], assigns["completed"]
				assert_equal u, flash["user"]				
		end								
end
