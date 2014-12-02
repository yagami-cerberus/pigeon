class CreateInspectionItems < ActiveRecord::Migration
  def change
    create_table :inspection_items do |t|
      t.string :title, null: false, limit: 128
      t.string :group_name, null: false, limit: 64
      t.string :code, null: true, limit: 64
      t.string :sample_type, null: false, limit: 64
    end
  end
end
