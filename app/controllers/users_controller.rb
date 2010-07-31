class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]  
  
  def add_game_to_list
    User.transaction do
      g = GameInformation.create
      para = {:user_id => current_user.id, :game_id => Game.find_by_name(params["name"]).id, :info_id => g.id}
      h = GameInformationMap.new(para)
      h.save
    end
    redirect_to :controller => "game_list", :action => "index"
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
