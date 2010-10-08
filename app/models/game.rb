class Game < ActiveRecord::Base
  has_many :game_information_maps
  has_many :users, :through => :game_information_maps
  validates_uniqueness_of :name, :scope => :platform, :case_sensitive => false
end
