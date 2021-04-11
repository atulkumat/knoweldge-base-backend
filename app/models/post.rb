class Post < ApplicationRecord 
  enum visibility: [:general, :hidden]

  belongs_to :user 
  has_many :bookmarks
  has_many :post_groups 
  has_many :comments
  has_many :post_tags 
  has_many :post_votes
  has_many :tags, through: :post_tags   
  has_many :groups, through: :post_groups 
  
  validates_presence_of :title, :description
  validates_numericality_of :upvotes, :downvotes, greater_than_or_equal_to: 0

  def up_vote(vote_entry, current_user_id, post_id)
    if vote_entry
      begin 
      Post.transaction do
        self.update!(upvotes: self.upvotes + 1, downvotes: self.downvotes - 1)
        vote_entry.status = :upvote
        vote_entry.save!
        return vote_entry, true 
      rescue => exception  
        return exception, false 
      end
      end 
    else  
      begin 
        Post.transaction do
          self.update!(upvotes: self.upvotes + 1)
          vote_entry = PostVote.new(post_id: post_id, user_id: current_user_id,
                                     status: :upvote)
          vote_entry.save!
        return vote_entry, true 
      rescue => exception  
        return exception, false 
        end 
      end 
    end  
  end 

  def down_vote(vote_entry, current_user_id, post_id)
    if vote_entry
      begin 
        Post.transaction do
          self.update!(upvotes: self.upvotes - 1, downvotes: self.downvotes + 1)
          vote_entry.status = :downvote
          vote_entry.save!
          return vote_entry, true 
        rescue => exception  
          return exception, false 
        end
      end  
    else  
      begin   
        Post.transaction do
          self.update!(downvotes: self.downvotes+1)
          vote_entry = PostVote.new(post_id: post_id, user_id: current_user_id, 
                                    status: :downvote)
          vote_entry.save!
          return vote_entry, true 
        rescue => exception  
          return exception, false 
        end 
      end 
    end
  end 
end
