class AllowUserPasswordNull < ActiveRecord::Migration
  def change
    change_column :users, :hashed_password, :string, :length => 128, :null => true
  end
end
