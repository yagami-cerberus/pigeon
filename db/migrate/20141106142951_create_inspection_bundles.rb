class CreateInspectionBundles < ActiveRecord::Migration
  def change
    create_table :inspection_bundles do |t|
      t.string :title, null: false, limit: 128
      t.string :group_name, null: false, limit: 64
      t.string :code, null: true, limit: 64
  
      t.integer :item_ids, array: true, null: false
    end
  end
end
