class User < ApplicationRecord
    has_secure_password

    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    validates :password, length: { minimum: 6}, if: -> {new_record? || !password.nil? }

    # add the relationship from User to post
    has_many :posts, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_many :liked_posts, through: :likes, source: :post


end
