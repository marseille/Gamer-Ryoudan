class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]  
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def save_attribute 
    user = current_user    
    game_info = GameInformation.find_by_user_id_and_game_id(user["id"], Game.find_by_name(params["game"]))          
    game_info[params["field"]] = params["new_value"]
    game_info.save
    retval = game_info[params["field"]]
    retval = [game_info[params["field"]], game_info["last_level"]] if params["field"] == "current_level"
    render :json => retval.to_json
  end
    
  def add_game_to_list
    game_name = params["game"]
    game = Game.find_by_name(game_name)    
    user = current_user
    params["game_information"]["user_id"] = user["id"]
    params["game_information"]["game_id"] = game["id"]
    GameInformation.transaction do 
      if !GameInformation.find_by_user_id_and_game_id(user["id"], game["id"])
        GameInformation.create(params["game_information"])      
        GameInformationMap.create(:user_id => user["id"], :game_id => game["id"])
      else 
        flash["notice"] = "This game already exists on your list!"
      end
    end
    
    if params["flash"]
      flash[:notice] += params["flash"] if params["flash"]
      flash[:notice] += "\n\n Successfully added '"+game_name+"' to your list!"
    else    
      flash[:notice] = "Successfully added '"+game_name+"' to your list!"
    end
    render :file => "games/index.html", :layout => "application"
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
    flash[:notice] = "Account registered!"
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
