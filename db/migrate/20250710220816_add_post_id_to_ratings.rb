class AddPostIdToRatings < ActiveRecord::Migration[8.0]
  def change
    add_reference :ratings, :post, null: false, foreign_key: true
  end
end
