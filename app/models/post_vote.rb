class PostVote < ApplicationRecord
  enum status: [:upvote, :downvote]

  belongs_to :user 
  belongs_to :post

  validates_presence_of :status
  validates_uniqueness_of :user_id, scope: :post_id 
end
