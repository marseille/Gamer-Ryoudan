class User < ActiveRecord::Base
  acts_as_authentic
  has_many :game_information_maps
  has_many :games, :through => :game_information_maps  

  def currently_playing
    
  end
  
  def on_hold
    
  end
  
  def completed
    
  end
  
  def plan_to_play
    
  end
end
