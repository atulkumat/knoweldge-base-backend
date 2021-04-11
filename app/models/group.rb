class Group < ApplicationRecord
  has_many :user_groups 
  has_many :post_groups, dependent: :destroy
  has_many :users, through: :user_groups
  has_many :posts,  through: :post_groups

  validates :name, presence: true, uniqueness: true
end
