class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]  
  before_filter :require_user, :only => [:show, 
                                                          :edit, 
                                                          :update,
                                                          :save_attribute,
                                                          :code_image,
                                                          :save_avatar,
                                                          :add_game_to_list,
                                                          :remove_game_from_list]
  require 'RMagick'
  require 'aws/s3'
  require 'rest-client'
  
  def save_attribute     
    user = current_user        
    
    #Make sure to use a game's id instead of it's name. Since there
    #can be more than one game with the same name
    game_info = GameInformation.find_by_user_id_and_game_id(user["id"], params["game"])                              
    game_info[params["field"]] = params["new_value"]
    game_info.save
    retval = game_info[params["field"]]    
    render :json => retval.to_json
  end  
  
  def save_avatar    
    begin      
      user = current_user            
      filename = "Avatars/"+user["login"] +"_avatar.png"    
      magicks = Magick::Image.from_blob(params["yourfilename"].read)                
      magicks.first.change_geometry!("54x50!") {|cols,rows,img| img.resize!(54,50)}        
      AWS::S3::Base.establish_connection!(:access_key_id => ENV["AMAZON_ACCESS_ID"], :secret_access_key => ENV["AMAZON_ACCESS_KEY"])                            
      if AWS::S3::S3Object.exists?(filename, 'gamer-ryoudan-avatars')
        AWS::S3::S3Object.delete(filename, 'gamer-ryoudan-avatars')
        AWS::S3::S3Object.store(filename, magicks.first.to_blob, 'gamer-ryoudan-avatars', :access => :public_read)        
        user["avatar_path"] = "https://s3.amazonaws.com/gamer-ryoudan-avatars/#{filename}"      
      elsif user["avatar_path"] === "https://s3.amazonaws.com/gamer-ryoudan-avatars/Avatars/default.png"
        AWS::S3::S3Object.store(filename, magicks.first.to_blob, 'gamer-ryoudan-avatars', :access => :public_read)        
        user["avatar_path"] = "https://s3.amazonaws.com/gamer-ryoudan-avatars/#{filename}"
      else                
        user["avatar_path"] = "https://s3.amazonaws.com/gamer-ryoudan-avatars/Avatars/default.png"    
      end      
      user.save!
    rescue => e 
      Rails.logger.error(e)
      Rails.logger.error(e.application_backtrace().join("/n"))
    end    
    render :nothing => true
  end
  
  def default_parameters(collection)
    collection.each do |stat|
      collection[stat.first] = "-" if stat[1] == ""
    end      
  end
  
  def add_game_to_list                
    game = Game.find_by_name_and_platform(params["game"]["name"],params["game"]["platform"])            
    user = current_user
    game_params = game_info_params
    game_params["user_id"] = user["id"]
    game_params["game_id"] = game["id"]
    #params["game_information"] = default_parameters(params["game_information"])    
    GameInformation.transaction do       
      begin        
        info_found = GameInformation.find_by_user_id_and_game_id(user["id"], game["id"])
        if !info_found          
          GameInformation.create(game_params)      
          GameInformationMap.create(:user_id => user["id"], :game_id => game["id"])
          flash["notice"] = "Added!"
        else           
          flash["notice"] = update_game_info(params["game_information"], info_found)
        end
      rescue => exc
        flash["notice"] = "Failed to add/save :("        
      end
    end    
    render :json => flash["notice"].to_json    
  end
  
  def update_game_info(collection, game_information)    
    collection.each do |stat|
      game_information[stat.first] = stat[1]            
    end
    game_information.save!
    "Saved!"
  end
  
  def remove_game_from_list
    User.transaction do      
      user = current_user
      g = Game.find(params["game_id"])     
      h = GameInformationMap.find_by_game_id_and_user_id(g.id, user.id)
      game_info = GameInformation.find_by_user_id_and_game_id(user["id"], g["id"])
      if h.delete && game_info.delete        
        flash[:notice] = "Removed!"        
      else
        flash[:notice] = "Failed :("        
      end      
    end
    render :text => flash[:notice]    
  end
  
  def new    
    flash["error"] = permitted_params(params)["error"] if params["error"]
    @user = User.new
  end
  
  def create    
    @user = User.new(permitted_params(params))    
    @user["avatar_path"] = "https://s3.amazonaws.com/gamer-ryoudan-avatars/Avatars/default.png"
    password = permitted_params(params)["password"]    
    email = permitted_params(params)[game_info_params"email"]    
    disposable = (email.include?("@")) ? disposable_email?(email) : false
    flash["error"] = "Come on. No disposable emails.." if disposable 
    if flash["error"].nil?  && @user.save
      flash[:notice] = "Account registered!"
      Emailer.created_account(email, @user["login"]).deliver
      #Emailer.deliver_new_signup(email, @user["login"])      
      redirect_to "/home"      
    else      
      render :action => :new, :params => {"error" => flash["error"]}
    end
  end
  
  def show
    @user = @current_user
  end

  def edit    
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent    
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
    end      
    render :action => :edit    
  end
  
  private
  
    def permitted_params(params)
      params.require(:user).permit(:login, :password, :password_confirmation, :email)
    end
  
    def disposable_email_check_url
      "http://check.block-disposable-email.com/api/json/#{ENV["DEA_API_KEY"]}/"            
    end
    
    def disposable_email?(email)
      email_domain = email.split("@").last
      domain_check_json = RestClient.get(disposable_email_check_url + email_domain)
      domain_check = JSON.parse(domain_check_json)    
      email_invalid = domain_check["domain_status"].eql?("block")          
    end
    
  def game_info_params
    params.require(:game_information).permit(:hours_played, :difficulty, :score, :status)
  end
end
