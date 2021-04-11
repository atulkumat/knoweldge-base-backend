class PostPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end
  
  def comments?
    @post.general? || UserGroup.where(user_id: user.id, group_id: @post.groups).exists?
  end

  def show?
    @post.general? || UserGroup.where(user_id: user.id, group_id: @post.groups).exists?
  end  

  def update?
    post.user_id == user.id
  end
end
