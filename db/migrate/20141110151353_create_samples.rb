class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.references :issue, null: false
      
      t.string :no, null: false, limit: 64
      t.string :sample_type, null: false, limit: 32
      t.integer :quantity, null: false
      
      t.timestamps
    end
  end
end
