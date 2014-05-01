class Emailer < ActionMailer::Base
  default :from => "do.not.reply.gamer.ryoudan@gmail.com", :to => "gamer.ryoudan@gmail.com"
   
 def error(url, exception, user, params)        
    @url = url
    @exception = exception
    @user = user
    @params = params
    mail(:subject => "error - Failed at #{url}")
  end
  
  def created_account(to_email, username)
    @username = username
    mail(:to => to_email,:subject => "Your new account on the Gamer Ryoudan")
  end
  
  def new_signup(to_email, username)
    @username = username
    mail(:to => to_email, :subject => "#{username} has joined the Gamer Ryoudan!")
  end
  
  def game_request(game, username)
    @game = game
    @username = username
    mail(:subject => "Add game request to the Gamer-Ryoudan!")
  end
  
  def feedback(username, email, subject, body)
    @email = email
    @feedback = body
    mail(:subject => "#{username} has Gamer-ryoudan feedback - #{subject}")
  end
end
