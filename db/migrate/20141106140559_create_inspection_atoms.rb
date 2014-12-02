class CreateInspectionAtoms < ActiveRecord::Migration
  def change
    create_table :inspection_atoms do |t|
      t.references :inspection_item
      t.string :title, null: false, limit: 128
      t.string :code, null: false, limit: 64
      t.string :unit, null: false, limit: 16
      t.integer :order_index, null: false, default: 0
      
      t.string :data_type, null: false, limit: 32
      t.text :data_descriptor, :null => false
      t.string :program_code, null: false, limit: 64
    end
  end
end
