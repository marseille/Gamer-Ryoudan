class GamesController < ApplicationController  
  before_filter :require_user, :only => [:add_game, :new_game]
  require 'will_paginate'  
  
  def new_game
    render :file => "/games/new_game_generic.html.erb", :layout => "application"
  end
  
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
    @home_search = params["home_search"]        
    @games = parse_and_find_games(@search_tag)            
    @result_count = @games.count
    @start_interval = params["page"].to_i ||= 1; (@start_interval * 20) - 19
    @end_interval = params["page"].to_i ||= 1; (@end_interval * 20)    
    #@start_interval = 1
    #@end_interval = 2
    @game_results = @games.paginate({:page => params[:page], :per_page => 20})        
    (@games.empty?) ? render_for_new_game(@search_tag) : render_for_search_results(@home_search)    
  end
  
  def parse_and_find_games(search_tag)
    games = ""
    if search_tag.include?("[")
      name = search_tag.split("[").first
      platform = search_tag.split("[")[1].gsub(/["\[\]"]/,"")    
      games = [Game.find_by_name_and_platform(name,platform)]
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
      render :partial => "games/search_results" 
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
      render :json => "added to list and db".to_json if !params["home_search"] 
      render :file => "/games/new_game_generic.html.erb", :layout => "application" if params["home_search"]
    else
      render :json => "added to db".to_json if !params["home_search"]            
      render :file => "/games/new_game_generic.html.erb", :layout => "application" if params["home_search"]
    end
  end
end