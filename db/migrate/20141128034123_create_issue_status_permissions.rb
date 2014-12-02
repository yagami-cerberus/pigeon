class CreateIssueStatusPermissions < ActiveRecord::Migration
  def change
    create_table :issue_status_permissions do |t|
      t.references :issue_status, null: false
      t.references :group, null: false
      t.integer :permission_flags, null: false, default: 0
      t.integer :issue_status_ids, null: false, array: true
    end
    
    add_index :issue_status_permissions, [:issue_status_id, :group_id], :unique => true
  end
end
