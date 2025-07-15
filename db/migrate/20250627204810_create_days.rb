class CreateDays < ActiveRecord::Migration[8.0]
  def change
    create_table :days do |t|
      t.integer :day_number
      t.string :day_intro
      t.string :day_picture_url
      t.text :day_description
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
