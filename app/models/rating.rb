class Rating < ApplicationRecord
  
  # Relationships
  belongs_to :post
  belongs_to :user

  # Validations
  validates :overall, presence: true
  validates :visit_again, presence: true
  validates :cost, presence: true
  validates :summary, presence: true

  # Default

end
