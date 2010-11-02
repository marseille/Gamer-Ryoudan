class AddAvatarDataToUsers < ActiveRecord::Migration
  def self.up
    
  end
  execute 'ALTER TABLE users ADD COLUMN avatar BINARY'
  
  def self.down
  end
end
