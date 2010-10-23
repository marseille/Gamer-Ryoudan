class AddImageFieldToAvatarsBecauseItDidntGetAddedBeforeQuestionMark < ActiveRecord::Migration
  def self.up
  end

  execute 'ALTER TABLE avatars ADD COLUMN image LONGBLOB'

  def self.down
  end
end
