class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.references :user
      t.references :group
    end
    
    add_index :user_groups, [:user_id, :group_id], :unique => true
  end
end
