class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :name, :null => false
      t.string :platform, :null => false
      t.timestamps      
    end    
  end  

  def self.down    
    drop_table :games    
  end  
end


