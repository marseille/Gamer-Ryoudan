class Emailer < ActionMailer::Base
 
 def default_email_address
   "gamer.ryoudan@gmail.com"
 end
 
 def do_not_reply
    "do.not.reply.gamer.ryoudan@gmail.com"
 end
 
 def error(url, exception, user, params)        
    recipients [default_email_address]
    from [do_not_reply]
    subject "ERROR!: Failed at #{url}"
    body %&    
    The Gamer Ryoudan website has crashed with the following information:
      message:#{exception.message}
      url:"#{url}"
      args: "#{params.collect {|param| param.to_a}}"
      user:"#{user['login']}"
      user\'s email:"#{user['email']}"
      stacktrace:        
    
    #{exception.application_backtrace.join("\n")}
        
    &
  end
  
  def created_account(to_email, username, password)
    recipients [to_email]
    from [do_not_reply]
    subject "Your new account on the Gamer Ryoudan"
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
  recipients [default_email_address]
    from [do_not_reply]
    subject "#{username} has joined the Gamer Ryoudan!"
     body <<-eos  
  A person by the email, "#{to_email}", has registered an account
  with the username: "#{username}"

  Long live the revolution!
    
  http://gamer-ryoudan.heroku.com
	 
	              eos
  end
  
  def game_request(game, username)
    recipients [default_email_address]
    from [do_not_reply]
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
    recipients [default_email_address]
    from [do_not_reply]
    subject "Gamer ryoudan feedback - #{subject}"
    body_str = %&
    #{username} with email address #{email} has sent in their feedback!
      
      #{body}
      
      --#{username}
      
end feedback&
    body body_str
  end
end