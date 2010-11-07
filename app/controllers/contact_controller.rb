class ContactController < ApplicationController  

  def feedback
    user = current_user
    Emailer.deliver_feedback(user["login"], user["email"], params["subject"], params["body"])
    flash[:notice] = "Email sent!"
    render :file => "/contact/index.html.erb", :layout => "application"
  end
end
