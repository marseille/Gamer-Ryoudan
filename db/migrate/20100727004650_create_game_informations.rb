class CreateGameInformations < ActiveRecord::Migration
  def self.up
    create_table :game_informations do |t|
      t.integer :percent_complete
      t.string :hours_played
      t.integer :achievement_current
      t.integer :acheivement_max
      t.string :difficulty      
      t.timestamps
    end
  end

  def self.down
    drop_table :game_informations
  end
end
