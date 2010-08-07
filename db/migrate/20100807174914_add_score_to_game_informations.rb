class AddScoreToGameInformations < ActiveRecord::Migration
  def self.up
    add_column :game_informations, :score, :integer
  end

  def self.down
  end
end
