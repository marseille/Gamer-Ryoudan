class GameListController < ApplicationController
  def index
    user = current_user
    games = user.games
    @currently_playing = []
    @hiatus = []
    @planned_games = []
    @completed = []
    @orphans = []
    games.each do |game| 
      game_info = GameInformation.find_by_user_id_and_game_id(user.id, game.id)
      next if !game_info
      title = game.name
      platform = game.platform
      case game_info.status 
        when "Campaigns" then @currently_playing.push([game,game_info])
        when "Centrum Contentus" then @hiatus.push([game,game_info])
        when "Contrived Crusades" then @planned_games.push([game,game_info])
        when "Conquests" then @completed.push([game,game_info])
        else @orphans.push([game,game_info])
      end
    end
    flash[:notice] = "orphaned games noticed! scroll down for more information" if !@orphans.empty?
    @warning = "not nil" if !@orphans.empty?      
    flash["notice"] = params["flash"] if params["flash"]
  end
end
