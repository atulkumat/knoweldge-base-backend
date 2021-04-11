class CommentVote < ApplicationRecord
  enum status: [:upvote, :downvote]

  belongs_to :user 
  belongs_to :comment 

  validates_presence_of :status
  validates_uniqueness_of :user_id, scope: :comment_id
end
