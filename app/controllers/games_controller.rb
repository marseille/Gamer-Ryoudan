class GamesController < ApplicationController  
  before_filter :require_user, :only => [:add_game, :new_game]  
  require 'will_paginate'      

  def add_game    
    flash[:notice] = ""
    game = Game.new(game_params)    
    if Game.find_by_name_and_platform(params["game"]["name"],params["game"]["platform"])
      render :json => "That game already exists".to_json
      return
    end    												

    if params["add_to_list"]          
      user = current_user
      params["game_information"]["user_id"] = user["id"]
      #need to organize a queue of games that need to be added to
      #list but are not added to the database yet
      #params["game_information"]["game_id"] = game["id"]      
      Emailer.game_request(params, current_user["login"])
      render :json => "Your request has been submitted! Thank you for making the Gamer Ryoudan better.".to_json if !params["home_search"]       
      render :file => "/games/new_game_generic.html.erb", :layout => "application" if params["home_search"]
    else
      Emailer.game_request(params, current_user["login"])      
      render :json => "Your request has been submitted! Thank you for making the Gamer Ryoudan better.".to_json if !params["home_search"]                  
      render :file => "/games/new_game_generic.html.erb", :layout => "application" if params["home_search"]
    end
  end

  #search query for autocompleting search box		
  def autocomplete_game_search    				        
    @games = Game.name_like(params["q"])[0..10]
    platform_result = Game.platform_like(params["q"])[0..10]    
    @games = @games.push(platform_result).flatten
    @games = @games.to_enum.uniq_by {|game| game["id"]}                
    render :json => @games.flatten.collect {|game| [game["name"] + " ["+game["platform"]+"]", game["platform"]]}
  end		
  
  #Finds a game from the text inputted in the search box. Relays the search results
  #to the view where the results are displayed and paginated.
  def find_game                        
    @search_tag = params["search_tag"]        
    @home_search ||= params["home_search"]
    @page = (params["page"]) ? params["page"] : 1
    @games = (@search_tag) ? parse_and_find_games(@search_tag) : Game.find(:all)
    @result_count = @games.count    
    @start_interval = get_start_and_end_pagination_intervals(params["page"], @result_count).first
    @end_interval = get_start_and_end_pagination_intervals(params["page"], @result_count)[1]
    @game_results = @games.paginate({:page => params[:page], :per_page => 20})                
    (@games.empty?) ? render_for_new_game(@search_tag) : render_for_search_results(@home_search)    
  end				
		
  def new_game
    @game = Game.new
    render :file => "/games/new_game_generic.html.erb", :layout => "application"
  end  
		
  private 				
		
    #first element is start interval, second (last) element is end interval		
    def get_start_and_end_pagination_intervals(page, result_count)
      intervals = []
      start_interval = (page) ? page.to_i : 1    
      start_interval = (start_interval * 20) - 19
      end_interval = (page) ? page.to_i : 1
      end_interval = (result_count < (end_interval * 20)) ? result_count : (end_interval * 20)                				
      intervals[0] = start_interval
      intervals[1] = end_interval
      intervals
    end
		
    #If the search text includes formatting from the autocomplete search, 
    #parse it, and search for games that match or are similar to it.
    def parse_and_find_games(search_tag)    
      games = ""
      if search_tag.include?("[")
        name = search_tag.split("[").first
        platform = search_tag.split("[")[1].gsub(/["\[\]"]/,"")          
        games = [Game.find_by_name_and_platform(name.strip,platform)]
      else 
        games = Game.name_or_platform_like(search_tag)
      end    
      games
    end		
				
    #pagination renderer for when no search results are found.
    #so instead of saying no results found, we ask them to add the game
    #to our library. This can happen on the home page, ajax-like, or on a 
    #separate page.
    def render_for_new_game(search_tag)
      @game = Game.new("name" => search_tag)
      if !params["home_search"]
        @renderer = "WillPaginate::LinkRenderer"
        render :file => "games/new_game.html.erb", :layout => "application"    
      else
        @renderer = "PaginationListLinkRenderer"
        render :partial => "shared/add_game_and_to_list", :locals => {:only_submit => true}
      end
    end

    #pagination renderer for when search results are found. Will display on 
    #either the home page, ajax-like, or on a separate page.
    def render_for_search_results(home_search)
      if !home_search      
        @renderer = "WillPaginate::LinkRenderer"
        render :file => "games/index.html", :layout => "application"
      else        
        @renderer = "PaginationListLinkRenderer"
        render :partial => "games/paginated_game_results" 
      end
    end	
    
private
  def game_params
    params.require(:game).permit(:name, :platform)
  end
end