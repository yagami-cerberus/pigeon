class CreateIssueBundles < ActiveRecord::Migration
  def change
    create_table :issue_bundles do |t|
      t.references :issue, null: false
      t.references :inspection_bundle, null: true
      t.integer :inspection_item_ids, array: true, null: false
      t.boolean :locked, null: false, default: false
      
      t.datetime :updated_at, null: false
    end
  end
end
