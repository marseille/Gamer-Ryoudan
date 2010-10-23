class AddAvatarSmallFileToUsers < ActiveRecord::Migration
  def self.up
    
  end
  execute 'ALTER TABLE users ADD COLUMN avatar_small_file LONGBLOB'
  def self.down
  end
end
