class MoveGameIdAndUserIdToGameInformationsForJustice < ActiveRecord::Migration
  def self.up
    add_column :game_informations, :user_id, :integer
    add_column :game_informations, :game_id, :integer
  end

  def self.down
  end
end
