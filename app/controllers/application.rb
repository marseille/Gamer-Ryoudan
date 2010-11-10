# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'pp'
require 'ruby-github'

class ApplicationController < ActionController::Base
  protect_from_forgery :except => [:add_game_to_list]  
  around_filter :handle_error  
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user, :recent_changes

  private   
  def handle_error
    yield      
    rescue => exception            
      user = current_user
      user = {"login" => "anonymous", "email" => "anonymous"} if !user           
      Emailer.deliver_error(request.request_uri,exception, user,params.collect{|param| param.to_a})      
      Rails.logger.error(exception)
  end  
  
  def recent_changes                
    commits = GitHub::API.new({"use_ssl" => true}).commits("marseille","gamer-ryoudan")
    latest_commits = commits[0..9]    
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
