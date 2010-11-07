class AddUserAvatarPathAsAttributeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :avatar_path, :string, :default => "https://s3.amazonaws.com/gamer-ryoudan-avatars/Avatars/default.png"
  end

  def self.down
  end
end
