class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
          :validatable

  enum gender: [:male, :female, :others]
  enum status: [:online, :offline]

  has_many :user_groups 
  has_many :posts
  has_many :comments 
  has_many :replies
  has_many :post_votes
  has_many :comment_votes
  has_many :bookmarks
  has_many :groups, through: :user_groups

  validates_presence_of :first_name, :gender, :dob
end
