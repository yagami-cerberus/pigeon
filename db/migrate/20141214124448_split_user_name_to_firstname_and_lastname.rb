class SplitUserNameToFirstnameAndLastname < ActiveRecord::Migration
  def change
    rename_column :users, :name, :firstname
    add_column :users, :lastname, :string, :length => 128, :null => false, :default => '', after: :firstname
    change_column_default :users, :lastname, nil
  end
end
