class GamesController < ApplicationController  
  
  def find_game    
    @game = Game.find_by_name(params["search_tag"])
    if @game      
      render :file => "games/index.html", :layout => "application" if params["load_page"].eql?("true")
      render :partial => "games/search_results" if !params["load_page"].eql?("true")
    else
      flash[:notice] = "Couldn't find your game, add it to the database nao!"
      @name = params["search_tag"]
      render :file => "games/new_game.html.erb", :layout => "application" if params["load_page"].eql?("true")
      render :partial => "shared/add_game_and_to_list", :locals => {:only_submit => true} if !params["load_page"].eql?("true")
    end
  end
  
  def add_game    
    game = Game.new({"platform"=>params["platform"], "name" => params["name"]})
    if game.save
      flash[:notice] = "Thank you for adding this game to the database's knowledge base!"
    else
      flash[:notice] = "There was an error processing your add request for:" + game["name"]
    end
    if params["add_to_list"]      
      #render :file => "games/index.html", :layout => "application"
      #render_component :controller =>"users", 
      #                              :action => "add_game_to_list",
      #                              :params => params
      
      #game_name = (params["name"]) ? params["name"] : Game.find(params["game"])["name"]
      game_name = game["name"]
      User.transaction do          
        g = GameInformation.create(:hours_played => params["hours_played"], 
                                                     :status => params["status"],
                                                     :score => params["score"],
                                                     :difficulty => params["difficulty"],
                                                     :current_level => params["current_level"])      
        para = {:user_id => current_user["id"],
                      :game_id => Game.find_by_name(game_name)["id"],
                      :game_information_id => g["id"]}
        h = GameInformationMap.new(para)
        h.save
      end    
      render :file => "games/index.html", :layout => "application"
    else
      render :file => "games/index.html", :layout => "application"
      #redirect_to  :controller => "game_list", :action => "index"
    end
  end
end