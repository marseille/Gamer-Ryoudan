class AddContentTypeToAvatarsBecauseSendDataNeedsIt < ActiveRecord::Migration
  def self.up
    add_column :avatars, :content_type, :string
  end

  def self.down
  end
end
