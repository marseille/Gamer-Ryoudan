class AddStatusToGameInformation < ActiveRecord::Migration
  def self.up
    add_column :game_informations, :status, :string, :null => false
  end

  def self.down
  end
end
