class GamesController < ApplicationController  
  
  def new_game
    render :file => "/games/new_game_generic.html.erb", :layout => "application"
  end
  
  def search_game
    @games = Game.name_like(params["q"]) 
    platform_result = Game.platform_like(params["q"])
    if !platform_result.empty? && (@games & platform_result).empty?      
      @games.push(platform_result)
    end    
    render :json => @games.flatten.collect {|game| [game["name"] + " ["+game["platform"]+"]", game["platform"]]}
  end
  
  def find_game        
    @games = ""
    if params["search_tag"].include?("[")
      name = params["search_tag"].split("[").first
      platform = params["search_tag"].split("[")[1].gsub(/["\[\]"]/,"")    
      @games = [Game.find_by_name_and_platform(name,platform)]      
    else 
      @games = Game.name_or_platform_like(params["search_tag"])
    end
    @game_information = GameInformation.new
    
    #still empty? that game must not exist yet.
    if @games.empty?          
      @game = Game.new
      @name = params["search_tag"]            
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
      game.save!
      flash["notice"] = "<label class=green_text>Successfully added this game to the database!</label>"
    else
      flash["notice"] = "<label class=red_text>There was an error processing your add request for:" + game["name"]+"</label>"
    end
    if params["add_to_list"]      
      game_name = game["name"]
      user = current_user
      params["game_information"]["user_id"] = user["id"]
      params["game_information"]["game_id"] = game["id"]
      GameInformation.transaction do        
        GameInformation.create(params["game_information"])      
        GameInformationMap.create(:user_id => user["id"], :game_id => game["id"])
      end
      render :json => "added to list and db".to_json if params["load_page"] 
      render :file => "/games/new_game_generic.html.erb", :layout => "application" if !params["load_page"]
    else
      render :json => "added to db".to_json if params["load_page"]
      
      #render :file => "games/index.html", :layout => "application"
      render :file => "/games/new_game_generic.html.erb", :layout => "application" if !params["load_page"]
    end
  end
end