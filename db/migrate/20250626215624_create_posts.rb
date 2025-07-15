class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.date :trip_date
      t.text :intro
      t.boolean :anonymous
      t.string :stayed_at
      t.string :picture_url
      t.integer :like_count
      t.integer :comment_count
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
