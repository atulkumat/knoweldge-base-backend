class PostVotePolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def upvote? 
    @post.general? || UserGroup.where(user_id: user.id, group_id: [@post.groups]).exists?
  end   

  def downvote?
    @post.general? || UserGroup.where(user_id: user.id, group_id: [@post.groups]).exists?
  end  
end
