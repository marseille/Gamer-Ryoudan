# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'pp'
require 'curb'
require 'nokogiri'

class ApplicationController < ActionController::Base
  protect_from_forgery :except => [:add_game_to_list]
  helper :all # include all helpers, all the time
  before_filter :require_user, :except => []  
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user, :get_latest_commits

  private 
  
  def get_latest_commits
    curl_str = Curl::Easy.perform("http://github.com/marseille/Gamer-ryoudan/commits/master").body_str
    noko_parser = Nokogiri::HTML(curl_str)
    commit_html = noko_parser.css('.separator')    
    latest_two_dates = [commit_html.children.children.first.text, 
                                   commit_html.children.children[1].text, 
                                   commit_html.children.children[2].text]
    commit_html = noko_parser.css('.group')    
    ridiculous_children_array = commit_html.children.children.children.children.children.children
    newest_commit_message = ridiculous_children_array.first.text
    second_newest_commit = ridiculous_children_array[4].text
    third_newest_commit = ridiculous_children_array[8].text        
    
    @latest_commits = [[latest_two_dates.first,newest_commit_message],
                                   [latest_two_dates[1], second_newest_commit],
                                   [latest_two_dates[2], third_newest_commit]]
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to "/user_sessions/new"
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
