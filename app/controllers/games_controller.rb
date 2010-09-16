class GamesController < ApplicationController  
  
  def search_game
    @games = Game.name_like(params["q"]) 
    platform_result = Game.platform_like(params["q"])
    if !platform_result.empty? && (@games & platform_result).empty?      
      @games.push(platform_result)
    end    
    render :json => @games.flatten.collect {|game| [game["name"], game["platform"]]}
  end
  
  def find_game        
    @games = Game.name_or_platform_like(params["search_tag"])
    @game_information = GameInformation.new
    
    #still empty? that game must not exist yet.
    if @games.empty?          
      @game = Game.new
      @name = params["search_tag"]      
      flash[:notice] = "Couldn't find your game, add it to the database nao!"
      if params["load_page"] === "true"
        render :file => "games/new_game.html.erb", :layout => "application"    
      else
        render :partial => "shared/add_game_and_to_list", :locals => {:only_submit => true}
      end
    else
      if params["load_page"] === "true"
        render :file => "games/index.html", :layout => "application"
      else        
        render :partial => "games/search_results" 
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