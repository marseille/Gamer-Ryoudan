class GetRidOfUselessShatFromAvatarsTable < ActiveRecord::Migration
  def self.up
    remove_column :avatars, :description
    remove_column :avatars, :content_type
    remove_column :avatars, :filename
    remove_column :avatars, :binary_data
    remove_column :avatars, :created_at
    remove_column :avatars, :updated_at    
  end

  def self.down
  end
end
