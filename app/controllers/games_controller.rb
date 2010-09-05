class GamesController < ApplicationController  
  
  def find_game    
    @game = Game.find_by_name(params["search_tag"])
    @game_information = GameInformation.new
    if @game            
      render :file => "games/index.html", :layout => "application" if params["load_page"].eql?("true")
      render :partial => "games/search_results" if !params["load_page"].eql?("true")
    else
      @game = Game.new
      flash[:notice] = "Couldn't find your game, add it to the database nao!"
      @name = params["search_tag"]      
      if params["load_page"].eql?("true")
        render :file => "games/new_game.html.erb", :layout => "application"
      else
        render :partial => "shared/add_game_and_to_list", :locals => {:only_submit => true}
      end
    end
  end
  
  def add_game    
    game = Game.new(params["game"])
    if game.save
      flash[:notice] = "Thank you for adding this game to the database's knowledge base!"
    else
      flash[:notice] = "There was an error processing your add request for:" + game["name"]
    end
    if params["add_to_list"]      
      game_name = game["name"]
      user = current_user
      params["game_information"]["user_id"] = user["id"]
      params["game_information"]["game_id"] = game["id"]
      p game
      p user
      GameInformation.transaction do        
        GameInformation.create(params["game_information"])      
        GameInformationMap.create(:user_id => user["id"], :game_id => game["id"])
        p 'yay'
      end
      render :file => "games/index.html", :layout => "application"
    else
      render :file => "games/index.html", :layout => "application"
    end
  end
end