class AddUserIdToAvatars < ActiveRecord::Migration
  def self.up
    add_column :avatars, :user_id, :integer, :null => false
  end

  def self.down
  end
end
