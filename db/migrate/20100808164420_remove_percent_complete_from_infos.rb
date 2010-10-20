class RemovePercentCompleteFromInfos < ActiveRecord::Migration
  def self.up
    remove_column :game_informations, :percent_complete
  end

  def self.down
  end
end
