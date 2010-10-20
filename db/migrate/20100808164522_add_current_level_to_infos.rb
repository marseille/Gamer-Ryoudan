class AddCurrentLevelToInfos < ActiveRecord::Migration
  def self.up
    add_column :game_informations, :current_level, :string
  end

  def self.down
  end
end
