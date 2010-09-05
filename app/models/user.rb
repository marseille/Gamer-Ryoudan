class User < ActiveRecord::Base
  acts_as_authentic
  has_many :game_information_maps
  has_many :games, :through => :game_information_maps  
end
