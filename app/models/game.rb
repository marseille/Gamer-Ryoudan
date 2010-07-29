class Game < ActiveRecord::Base
  has_many :game_information_maps
  has_many :users, :through => :game_information_maps
  
  def find_info(info_id)
  end
end
