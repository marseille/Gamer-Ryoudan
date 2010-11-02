class JesusIKeepForgettingFieldsToTheAvatarsTable < ActiveRecord::Migration
  def self.up    
  end
  
  execute 'ALTER TABLE users ADD COLUMN image BINARY'
  
  def self.down
  end
end
