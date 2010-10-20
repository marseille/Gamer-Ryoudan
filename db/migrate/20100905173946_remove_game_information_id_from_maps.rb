class RemoveGameInformationIdFromMaps < ActiveRecord::Migration
  def self.up
    remove_column :game_information_maps, :game_information_id
  end

  def self.down
  end
end
