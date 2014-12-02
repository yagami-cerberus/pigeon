class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false, limit: 64
      t.string :hashed_password, null: false, limit: 128
      t.string :name, null: false, limit: 128
      t.string :email, null: true, limit: 128
      
      t.integer :flags, null: false, default: 0
      
      t.datetime :lastlogin_at, null: true
      t.timestamps
    end
    
    add_index :users, :username, unique: true
  end
end
