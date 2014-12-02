class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, null: false, limit: 32
      
      t.integer :system_flags, null: false, default: 0, limit: 8
    end
  end
end
