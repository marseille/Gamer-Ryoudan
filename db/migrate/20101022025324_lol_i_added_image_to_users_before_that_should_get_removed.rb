class LolIAddedImageToUsersBeforeThatShouldGetRemoved < ActiveRecord::Migration
  def self.up
    remove_column :users, :image
  end

  def self.down
  end
end
