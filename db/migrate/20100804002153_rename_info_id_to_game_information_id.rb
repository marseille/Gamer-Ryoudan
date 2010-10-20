class RenameInfoIdToGameInformationId < ActiveRecord::Migration
  def self.up
    rename_column :game_information_maps, :info_id, :game_information_id
  end

  def self.down
  end
end
