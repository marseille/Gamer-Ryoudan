class AddNumberOfLevelsToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :number_of_levels, :integer, :null => false
  end

  def self.down
  end
end
