class CreateIssueValues < ActiveRecord::Migration
  def change
    create_table :issue_values do |t|
      t.references :issue_bundle, null: false
      t.references :inspection_atom, null: false
      
      t.string :data, null: true, limit: 128
      t.boolean :override_error, null: true
      t.string :override_describe, null: true, limit: 256

      t.references :editor, null: true
      t.datetime :updated_at, null: false
    end
  end
end
