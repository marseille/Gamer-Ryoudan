class AddTheseAvatarColumnsOrElseIWillGetExceptionQuestionMark < ActiveRecord::Migration
  def self.up
  end

  execute 'ALTER TABLE users ADD COLUMN avatar_file BINARY'
  execute 'ALTER TABLE users ADD COLUMN avatar_medium_file BINARY'
  execute 'ALTER TABLE users ADD COLUMN avatar_thumb_file BINARY'

  def self.down
  end
end
