class AddAvatarDataToUsers < ActiveRecord::Migration
  def self.up
    
  end
  execute 'ALTER TABLE users ADD COLUMN avatar LONGBLOB'
  
  def self.down
  end
end
