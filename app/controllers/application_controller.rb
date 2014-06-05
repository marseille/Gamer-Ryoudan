# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'github_api'

class ApplicationController < ActionController::Base
 #around_filter :handle_error  
  helper_method :current_user_session, :current_user, :recent_changes

  protected
  def rescues_path(template_name)    
    "#{RAILS_ROOT}/public/500.html"
  end

  private   
  def handle_error
    yield      
    rescue => exception                        
      user = current_user      
      user = {"login" => "anonymous", "email" => "anonymous"} if !user           
      Emailer.error(request.path,exception, user,params.collect{|param| param.to_a}).deliver      
      Rails.logger.error(exception)
      raise exception
  end  
  
  def recent_changes                    
    begin
      repo = Github::Repos.new(:user => 'marseille', :repo => 'gamer-ryoudan')
      commits = repo.commits.all[0..9]
    rescue Exception => e
      #problem with github?
    end
    commits
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
      redirect_to request.base_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.original_url
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end

module Enumerable
  def uniq_by
    seen = Hash.new { |h,k| h[k] = true; false }
    reject { |v| seen[yield(v)] }
  end
end
