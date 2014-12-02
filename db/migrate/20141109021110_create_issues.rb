class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.references :profile, null: false
      t.references :issue_status, null: false
      t.references :created_by, null: false
      t.string :access_group, null: true
      t.timestamps
    end
  end
end
