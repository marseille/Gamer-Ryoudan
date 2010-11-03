class User < ActiveRecord::Base
  require 'aws/s3'
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
  
  def avatar    
    avatar_filename = "Avatars/"+self.login+"_avatar.png"        
    AWS::S3::Base.establish_connection!(:access_key_id => ENV["AMAZON_ACCESS_ID"], :secret_access_key => ENV["AMAZON_ACCESS_KEY"])
    avatar_object = AWS::S3::S3Object.find avatar_filename, 'gamer-ryoudan-avatars'               
  end
end
