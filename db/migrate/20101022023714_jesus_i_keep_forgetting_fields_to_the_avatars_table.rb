class JesusIKeepForgettingFieldsToTheAvatarsTable < ActiveRecord::Migration
  def self.up    
  end
  
  execute 'ALTER TABLE users ADD COLUMN image LONGBLOB'
  
  def self.down
  end
end
