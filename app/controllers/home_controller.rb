class HomeController < ApplicationController  
  before_filter :except => [:index]
    
  def index
  end  
  
end
