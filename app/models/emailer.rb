class Emailer < ActionMailer::Base
 def error(url, exception, user, params)        
    recipients ["gamer.ryoudan@gmail.com"]
    from ["do.not.replygr@gmail.com"]
    subject "ERROR!: Failed at #{url}"
    body %&    
    The Gamer Ryoudan website has crashed with the following information:
      message:#{exception.message}
      url:"#{url}"
      args: "#{params}"
      user:"#{user['login']}"
      user\'s email:"#{user['email']}"
      stacktrace:        
    
    #{exception.application_backtrace.join("\n")}
        
    &
  end
  
  def created_account(to_email, username, password)
    recipients [to_email]
    from ["do.not.replygr@gmail.com"]
    subject "Created account"
     body <<-eos  
	  
    An account has been created for you on the Gamer Ryoudan.
	                             
	  Your credentials are:
	
	  username:"#{username}"
	  password:"#{password}"    
  
	  You can log into the Gamer Ryoudan here:
	  http://gamer-ryoudan.heroku.com
	 
    Thanks for registering for the Gamer Ryoudan! I hope you enjoy
    it every bit as much I enjoyed making it.
    
    Marseille
    System Administrator
   
	              eos
  end
  
  def new_signup(to_email, username)
  recipients ["gamer.ryoudan@gmail.com"]
    from ["do.not.replygr@gmail.com"]
    subject "#{username} has joined the Gamer Ryoudan!"
     body <<-eos  
  A person by the email, "#{to_email}", has registered an account
  with the username: "#{username}"

  Long live the revolution!
    
  http://gamer-ryoudan.heroku.com
	 
	              eos
  end
  
  def game_request(game, username)
    recipients ["gamer.ryoudan@gmail.com"]
    from ["do.not.replygr@gmail.com"]
    subject "Add game request to the gamer-ryoudan!"
    body <<-eos
    #{username} has requested that you add this nonexistent
    game to the library of awesomeness: 
    
    name:#{game['game']['name']}
    platform:#{game['game']['platform']}    
    hours played: #{game['game_information']['hours_played'] if game['game_information']}
    difficulty: #{game['game_information']['difficulty'] if game['game_information']}
    score: #{game['game_information']['score'] if game['game_information']}
    status: #{game['game_information']['status'] if game['game_information']}    
          
    THAT IS ALL
    
    M    
    eos
  end
  
  def feedback(username, email, subject, body)
    recipients ["gamer.ryoudan@gmail.com"]
    from ["do.not.replygr@gmail.com"]
    subject "Gamer ryoudan feedback - #{subject}"
    body_str = %&
    #{username} with email address #{email} has sent in their feedback!
      
      #{body}
      
      --#{username}
      
end feedback&
    body body_str
  end
end