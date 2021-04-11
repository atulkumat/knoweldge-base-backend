class CommentPolicy
  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def create?
    @post.general? || UserGroup.where(user_id: user.id, group_id: [@post.groups]).exists?
  end

  def accept?
    return false if @post.user_id != user.id
    record = Comment.find_by(accepted: :true, post_id: @post.id)
    return  true if record.nil?
    false
  end   
end
