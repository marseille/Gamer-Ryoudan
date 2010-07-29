class GameInformationMap < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :game_information
end
