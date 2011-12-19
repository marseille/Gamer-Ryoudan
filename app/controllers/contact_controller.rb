class ContactController < ApplicationController  

  def index
    flash.delete(:notice) if flash[:notice]
  end

  def feedback
    user = current_user
    user = {"login" => "anonymous", "email" => "anonymous"} if !user    
    Emailer.deliver_feedback(user["login"], user["email"], params["subject"], params["body"])    
		flash[:notice] = "Email sent!"
    render :file => "/contact/index.html.erb", :layout => "application"
  end
end
