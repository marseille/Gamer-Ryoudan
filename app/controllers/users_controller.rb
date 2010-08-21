class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]  
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def add_game_to_list
    p params
    User.transaction do      
      g = GameInformation.create(:hours_played => params["hours_played"], 
                                                   :status => params["status"],
                                                   :score => params["score"],
                                                   :difficulty => params["difficulty"],
                                                   :current_level => params["current_level"])
      game_name = (params["name"]) ? params["name"] : Game.find(params["game"])["name"]
      para = {:user_id => current_user["id"],
                    :game_id => Game.find_by_name(game_name)["id"],
                    :game_information_id => g["id"]}
      h = GameInformationMap.new(para)
      h.save
    end    
    flash[:notice] = params["flash"]
    redirect_to :controller => "game_list"
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
