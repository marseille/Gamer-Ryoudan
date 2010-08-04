class GameListController < ApplicationController
  def index
    game_ids_and_info_ids = current_user.game_information_maps    
    currently_playing = []
    hiatus = []
    planned_games = []
    completed = []
    orphaned_games = []
    
    game_ids_and_info_ids.each do |id_set| 
      game = Game.find(id_set.game_id)
      info = GameInformation.find(id_set.game_information_id)
      title = game.name
      platform = game.platform
      pp info
      case info.status 
        when "Campaigns" then currently_playing.push([title,platform,info])
        when "Centrum Contentus" then hiatus.push([title,platform,info])
        when "Contrived Crusades" then planned_games.push([title,platform,info])
        when "Conquests" then completed.push([title,platform,info])
        else orphaned_games.push([title,platform,info])
      end
    end
    @currently_playing = currently_playing
    @hiatus = hiatus
    @planned_games = planned_games
    @completed = completed
    @orphans = orphaned_games
    @warning = "not nil" and flash[:notice] = "orphaned games noticed! scroll down for more information" if !@orphans.empty?      
  end
end
