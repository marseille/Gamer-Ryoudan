class CreateAvatars < ActiveRecord::Migration
  def self.up
    create_table :avatars do |t|
      t.column :description, :string
      t.column :content_type, :string
      t.column :filename, :string
      t.column :binary_data, :binary
      t.timestamps
    end
  end

  def self.down
    drop_table :avatars
  end
end
