class GameListController < ApplicationController
  before_filter :validate, :except => []
  
  def index                
				user = User.find(:first, :conditions => ["lower(login) = ?", params["user"].downcase])    
    games = user.games.sort {|game1, game2| game1["name"] <=> game2["name"]}        
				game_list = produce_game_list(games,user)				
				@currently_playing = game_list.first
    @hiatus = game_list[1]
    @planned = game_list[2]
    @completed = game_list[3]													
    flash["user"] = user				
				flash["notice"] = params["flash"] if params["flash"]
  end
  				
  def validate    
				#If no one's game list is specified and the user 
				#is not logged in, display a message
				if !params["user"] && !current_user
      flash["display_message"] = true
      redirect_to "/"						
						
				#if the list is not specified, but the user is logged in,
				#redirect to the logged in user's list.
    elsif !params["user"] && current_user
						redirect_to "/game_list/"+current_user["login"]												
    end
  end
		
		private 
		
		def produce_game_list(games,user)				
				game_list = [[], [], [], []]				
				
				games.each do |game|       
						game_info = GameInformation.find_by_user_id_and_game_id(user["id"], game["id"])						
      next if !game_info						      						      						
						case game_info["status"]
        when "Campaigns" then game_list.first.push([game,game_info])
        when "Centrum Contentus" then game_list[1].push([game,game_info])
        when "Contrived Crusades" then game_list[2].push([game,game_info])
        when "Conquests" then game_list.last.push([game,game_info])        
      end						
    end												
				game_list
		end				
end
