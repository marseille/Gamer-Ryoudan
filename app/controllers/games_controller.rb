class GamesController < ApplicationController  
  before_filter :require_user, :only => [:add_game, :new_game]  
  require 'will_paginate'  

  def new_game
    render :file => "/games/new_game_generic.html.erb", :layout => "application"
  end
  
  #search query for autocompleting search box
  #this should be renamed...search game and find game
  #sound too similar and that makes one think we only need one  
  def search_game    
    @games = Game.name_like(params["q"])[0..10]
    platform_result = Game.platform_like(params["q"])[0..10]
    if !platform_result.empty? && (@games & platform_result).empty?      
      @games.push(platform_result)
    end    
    render :json => @games.flatten.collect {|game| [game["name"] + " ["+game["platform"]+"]", game["platform"]]}
  end
  
  def find_game                
    @game_information = GameInformation.new
    @game = Game.new    
    @search_tag = params["search_tag"]        
    @home_search ||= params["home_search"]
    @page = (params["page"]) ? params["page"] : 1
    @games = (@search_tag) ? parse_and_find_games(@search_tag) : Game.find(:all)
    @result_count = @games.count    
    @start_interval = (params["page"]) ? params["page"].to_i : 1    
    @start_interval = (@start_interval * 20) - 19
    @end_interval = (params["page"]) ? params["page"].to_i : 1
    @end_interval = (@result_count < (@end_interval * 20)) ? @result_count : (@end_interval * 20)                				
    @game_results = @games.paginate({:page => params[:page], :per_page => 20})                
    (@games.empty?) ? render_for_new_game(@search_tag) : render_for_search_results(@home_search)    
  end
  
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
  
  def render_for_new_game(search_tag)
    if !params["home_search"]
      @renderer = "WillPaginate::LinkRenderer"
      render :file => "games/new_game.html.erb", :layout => "application"    
    else
      @renderer = "PaginationListLinkRenderer"
      render :partial => "shared/add_game_and_to_list", :locals => {:only_submit => true}
    end
  end
  
  def render_for_search_results(home_search)
    if !home_search      
      @renderer = "WillPaginate::LinkRenderer"
      render :file => "games/index.html", :layout => "application"
    else        
      @renderer = "PaginationListLinkRenderer"
      render :partial => "games/paginated_game_results" 
    end
  end
  
  def add_game    
    flash[:notice] = ""
    game = Game.new(params["game"])    
    if Game.find_by_name_and_platform(params["game"]["name"],params["game"]["platform"])
      render :json => "That game already exists".to_json
    else
      #if game.save
      #do nothing, yay.
      #render :json => "There was an error processing your add request".to_json
    end
    
    if params["add_to_list"]      
      game_name = game["name"]
      user = current_user
      params["game_information"]["user_id"] = user["id"]
      params["game_information"]["game_id"] = game["id"]      
      Emailer.deliver_game_request(params, current_user["login"])
      render :json => "Your request has been submitted! Thank you so much for your support!!".to_json if !params["home_search"]       
      render :file => "/games/new_game_generic.html.erb", :layout => "application" if params["home_search"]
    else
      Emailer.deliver_game_request(params, current_user["login"])      
      render :json => "Your request has been submitted! Thank you so much for your support!!".to_json if !params["home_search"]                  
      render :file => "/games/new_game_generic.html.erb", :layout => "application" if params["home_search"]
    end
  end
end