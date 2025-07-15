class CreateRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :ratings do |t|
      t.integer :overall
      t.integer :food
      t.integer :safety
      t.integer :cost
      t.string :transportation
      t.string :climate
      t.boolean :visit_again
      t.text :summary
      t.string :tags
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
