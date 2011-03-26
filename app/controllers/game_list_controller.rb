class GameListController < ApplicationController
  before_filter :validate, :except => []
  
  def index            
    @user = User.find(:first, :conditions => ["lower(login) = ?", params["user"].downcase])    
    games = @user.games
    @currently_playing = []
    @hiatus = []
    @planned_games = []
    @completed = []    
    games.each do |game| 
      game_info = GameInformation.find_by_user_id_and_game_id(@user["id"], game["id"])
      next if !game_info
      title = game.name
      platform = game.platform
      case game_info.status 
        when "Campaigns" then @currently_playing.push([game,game_info])
        when "Centrum Contentus" then @hiatus.push([game,game_info])
        when "Contrived Crusades" then @planned_games.push([game,game_info])
        when "Conquests" then @completed.push([game,game_info])        
      end
    end        
    flash["notice"] = params["flash"] if params["flash"]
  end
  
  def validate
    if !params["user"] && !current_user
      flash[:notice] = "<br /><label class=red_text>you need to specify a user if you're going to look at a list! <br /> ex:http://localhost:3000/game_list/user_name</label>" 
      redirect_to "/"
    elsif !params["user"] && current_user
      redirect_to "/game_list/"+current_user["login"]
    end
  end
end
