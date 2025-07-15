class ChangeRatingFieldsToDecimal < ActiveRecord::Migration[8.0]
  def change
    change_column :ratings, :overall, :decimal, precision: 3, scale: 1
    change_column :ratings, :food, :decimal, precision: 3, scale: 1
    change_column :ratings, :safety, :decimal, precision: 3, scale: 1
    change_column :ratings, :climate, :string
    change_column :ratings, :cost, :string
  end
end
