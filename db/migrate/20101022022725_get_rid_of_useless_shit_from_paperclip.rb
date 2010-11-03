class GetRidOfUselessShitFromPaperclip < ActiveRecord::Migration
  def self.up    
    remove_column :users, :avatar_file_name
    remove_column :users, :avatar_content_type
    remove_column :users, :avatar_file_size
    remove_column :users, :avatar_updated_at
    remove_column :users, :avatar_file
    remove_column :users, :avatar_medium_file
    remove_column :users, :avatar_thumb_file    
  end

  def self.down
  end
end
