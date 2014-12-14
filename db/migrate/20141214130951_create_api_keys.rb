class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.references :user, null: false
      t.string :key, null: false, limit: 64
      t.string :secret_key, null: false, limit: 128
      
      t.integer :flags, null: false, default: 0
      
      t.datetime :lastuse_at, null: true
      t.timestamps
    end

    add_index :api_keys, :key, unique: true
  end
end
