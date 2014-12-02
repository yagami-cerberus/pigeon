class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :identify, null: true, limit: 32
      t.string :firstname, null: false, limit: 128
      t.string :surname, null: false, limit: 128
      t.string :sex_flag, null: true, limit: 1
      t.date :birthday, null: true

      t.timestamps
    end
  end
end
