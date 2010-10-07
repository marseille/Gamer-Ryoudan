class MakeGameNamesUnique < ActiveRecord::Migration
  def self.up
    remove_column :games, :name
    add_column :games, :name, :string, :null => false, :unique => true
  end

  def self.down
  end
end
