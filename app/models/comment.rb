class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :replies
  has_many :comment_votes

  validates_presence_of :content
  validates_numericality_of :upvotes, :downvotes, greater_than_or_equal_to: 0

  def up_vote(comment_vote, user_id, comment_id)
    if comment_vote
      begin 
        Comment.transaction do
          self.update!(upvotes: self.upvotes + 1, downvotes: self.downvotes - 1)
          comment_vote.status = :upvote
          comment_vote.save!
          return comment_vote, true 
        rescue => e  
          return e, false 
        end
      end 
    else  
      begin 
        Comment.transaction do
          self.update!(upvotes: self.upvotes + 1)
          comment_vote = CommentVote.new(comment_id: comment_id, user_id: user_id,
                                     status: :upvote)
          comment_vote.save!
        return comment_vote, true 
      rescue => e  
        return e, false 
        end 
      end 
    end  
  end 

  def down_vote(comment_vote, user_id, comment_id)
    if comment_vote
      begin 
        Comment.transaction do
          self.update!(upvotes: self.upvotes - 1, downvotes: self.downvotes + 1)
          comment_vote.status = :downvote
          comment_vote.save!
          return comment_vote, true 
        rescue => e  
          return e, false 
        end
      end  
    else  
      begin   
        Comment.transaction do
          self.update!(downvotes: self.downvotes+1)
          comment_vote = CommentVote.new(comment_id: comment_id, user_id: user_id, 
                                    status: :downvote)
          comment_vote.save!
          return comment_vote, true 
        rescue => e  
          return e, false 
        end 
      end 
    end
  end 
end
