class User < ActiveRecord::Base  
  acts_as_authentic
  has_many :game_information_maps
  has_many :games, :through => :game_information_maps   

  def game_count(status_name)
    matched_games = []
    self.games.each do |game|
      match = GameInformation.find_by_user_id_and_game_id(self["id"],game["id"])["status"] === status_name
      matched_games.push(game) if match
    end
    matched_games
  end 
end