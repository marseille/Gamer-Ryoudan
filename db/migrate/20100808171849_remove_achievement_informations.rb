class RemoveAchievementInformations < ActiveRecord::Migration
  def self.up    
    remove_column :game_informations, :achievement_current
    remove_column :game_informations, :acheivement_max
  end

  def self.down
  end
end
