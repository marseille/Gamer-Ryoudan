class RemoveLastLevelFromGameInformations < ActiveRecord::Migration
  def self.up
    remove_column :game_informations, :last_level
  end

  def self.down
  end
end
