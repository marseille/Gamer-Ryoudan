class AddNotesToGameInformation < ActiveRecord::Migration
  def self.up
    add_column :game_informations, :notes, :string, :default => "-"
  end

  def self.down
  end
end
