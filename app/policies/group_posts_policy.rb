class GroupPostsPolicy
  attr_reader :user, :group

  def initialize(user, group)
    @user = user
    @group = group
  end

  def posts?
    group.user_groups.find_by(user_id: user.id).present?
  end  

  def create? 
    group.user_groups.find_by(user_id: user.id).present?   
  end  
end
