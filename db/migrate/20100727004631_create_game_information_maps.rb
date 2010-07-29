class CreateGameInformationMaps < ActiveRecord::Migration
  def self.up
    create_table :game_information_maps do |t|
      t.integer :game_id, :null => false
      t.integer :user_id, :null => false
      t.integer :info_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :game_information_maps
  end
end
