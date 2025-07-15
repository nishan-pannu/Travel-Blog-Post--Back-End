class Day < ApplicationRecord

  # Relationships
  belongs_to :post

  # Validations
  validates :day_number, presence: true
  validates :day_description, presence: true

  # Default values
  after_initialize :set_defaults

  private

  def set_defaults
    self.day_number ||= 1
  end

end
