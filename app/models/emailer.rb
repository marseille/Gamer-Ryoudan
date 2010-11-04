class Emailer < ActionMailer::Base
 def error(url, exception, stacktrace)    
    recipients ["gamer.ryoudan@gmail.com"]
    from ["do.not.replygr@gmail.com"]
    subject "ERROR!: Failed at #{url}"
    body "#{exception} \n #{stacktrace}"
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
	 
	              eos
  end
end
