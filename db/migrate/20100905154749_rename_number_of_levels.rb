class RenameNumberOfLevels < ActiveRecord::Migration
  def self.up
    rename_column :games, :number_of_levels, :levels
  end

  def self.down
  end
end
