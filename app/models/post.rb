class Post < ApplicationRecord

  # RELATIONSHIPS:
  # Relationships are connections between data
  # Types of Relationships: belongs_to, has_many, has_one
    # belongs_to = record is connected to ONE other record
      # Ex: the post you create belongs only to the user who created it
    # has_many =  record is connected to MULTIPLE other records
      # Ex: one user has many posts
      # Ex: one post can have many days
    # has_one = record is connected to exactly ONE other record
      # Ex: one post has one rating

  # this post belongs to only one user
  belongs_to :user

   # one post can have many days
   has_many :days, dependent: :destroy

   # one day can have one rating
   has_one :rating, dependent: :destroy





   # VALIDATIONS
   # Validations are the required parts of this model
   # For example, a title should be required to create a post
   validates :title, presence: true
   validates :intro, presence: true



  
   # DEFAULTS
   # Set the defalts of the like and commment counts
   # Says: after a post is created, call the set_defaults method
   after_initialize :set_defaults

  # private method for setting the default values
  private

  def set_defaults
    self.like_count ||= 0
    self.comment_count ||=0
    self.trip_date ||= Date.current
  end


end