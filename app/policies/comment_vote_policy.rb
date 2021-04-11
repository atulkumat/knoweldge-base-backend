class CommentVotePolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def upvote? 
    post = @comment.post
    post.general? || UserGroup.where(user_id: user.id, group_id: post.groups).exists?
  end   

  def downvote?
    post = comment.post
    post.general? || UserGroup.where(user_id: user.id, group_id: post.groups).exists?
  end  
end
