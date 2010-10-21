class AddTheseAvatarColumnsOrElseIWillGetExceptionQuestionMark < ActiveRecord::Migration
  def self.up
  end

  execute 'ALTER TABLE users ADD COLUMN avatar_file LONGBLOB'
  execute 'ALTER TABLE users ADD COLUMN avatar_medium_file LONGBLOB'
  execute 'ALTER TABLE users ADD COLUMN avatar_thumb_file LONGBLOB'

  def self.down
  end
end
