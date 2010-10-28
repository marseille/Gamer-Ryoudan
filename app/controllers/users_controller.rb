class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]  
  before_filter :require_user, :only => [:show, :edit, :update]
  protect_from_forgery :only => []
  require 'RMagick'
  
  def save_attribute 
    user = current_user    
    game_info = GameInformation.find_by_user_id_and_game_id(user["id"], Game.find_by_name(params["game"]))          
    game_info[params["field"]] = params["new_value"]
    game_info.save
    retval = game_info[params["field"]]    
    render :json => retval.to_json
  end
  
  def code_image     
    user = current_user
    @image = user.avatar["image"]    
    send_data(@image, :type => user.avatar["content_type"], 
                                   :filename => user["login"]+"_avatar", 
                                   :disposition => 'inline')
  end
  
  def save_avatar    
    user = current_user                  
    magicks = Magick::Image.from_blob(params["yourfilename"].read)            
    magicks.first.change_geometry!("54x50!") {|cols,rows,img| img.resize!(54,50)}    
    user.avatar = Avatar.create(:user_id => user["id"]) if user.avatar.nil?
    user.avatar["image"] = magicks.first.to_blob
    user.avatar["content_type"] = params["yourfilename"].content_type
    user.avatar.save!
    render :text => "success"
  end
  
  def add_game_to_list
    game_name = params["game"]
    game = Game.find_by_name(game_name)        
    user = current_user
    params["game_information"]["user_id"] = user["id"]
    params["game_information"]["game_id"] = game["id"]
    params["game_information"].attributes.each do |stat|
      params["game_information"][stat.first] = "-" if !stat[1]      
    end      
    GameInformation.transaction do       
      begin        
        info_found = GameInformation.find_by_user_id_and_game_id(user["id"], game["id"])
        if !info_found
          GameInformation.create(params["game_information"])      
          GameInformationMap.create(:user_id => user["id"], :game_id => game["id"])
          flash["notice"] = "Added!"
        else 
          #update the info
          params["game_information"].each do |stat|
            info_found[stat.first] = stat[1]
          end
          info_found.save!
          flash["notice"] = "Saved!"
        end
      rescue => exc
        flash["notice"] = "Failed to add/save :("
        #maybe do some logging here
      end
    end
    
    render :json => flash["notice"].to_json    
  end
  
  def remove_game_from_list
    User.transaction do
      g = Game.find_by_name(params["name"])
      h = GameInformationMap.find_by_game_id_and_user_id(g.id, current_user.id)
      if h.delete
        flash[:notice] = "#{params['name']} was successfully deleted from your list!"        
      else
        flash[:notice] = "Failed to remove #{params['name']} :("
      end
      redirect_to :controller => "game_list"
    end
  end
  
  def new    
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
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
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
