class GamesController < ApplicationController
  def find_game    
    @game = Game.find_by_name(params["search_tag"])
    if @game
      render :file => "games/index.html", :layout => "application"
    else
      flash[:notice] = "Couldn't find your game, add it to the database nao!"
      @name = params["search_tag"]
      render :file => "games/new_game.html.erb", :layout => "application"
    end
  end
  
  def add_game
    param = params["status"]
    game = Game.new({"platform"=>params["platform"], "name" => params["name"]})
    if game.save
      flash[:notice] = "SUHHHHHH-WEEEET!!! site haz moar " + params["name"]
    else
      flash[:notice] = "OHHHH SHEEEET"
    end
    if params["add_to_list"]
      redirect_to :controller => "users", 
                       :action => "add_game_to_list", 
                       :name => game.name, 
                       :something => param,
                       :flash => flash[:notice]
    else
      render :file => "game_list/index.html.erb"
    end
  end
end
