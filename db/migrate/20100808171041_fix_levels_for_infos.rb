class FixLevelsForInfos < ActiveRecord::Migration
  def self.up
    remove_column :game_informations, :current_level
    add_column :game_informations, :last_level, :integer
    add_column :game_informations, :current_level, :integer
  end

  def self.down
  end
end
