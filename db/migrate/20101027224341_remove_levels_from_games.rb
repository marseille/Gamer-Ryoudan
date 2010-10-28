class RemoveLevelsFromGames < ActiveRecord::Migration
  def self.up
    remove_column :games, :levels
    remove_column :game_informations, :current_level
  end

  def self.down
  end
end
