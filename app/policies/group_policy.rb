class GroupPolicy
  attr_reader :user, :group

  def initialize(user, group)
    @user = user
    @group = group
  end

  def update?
    user_group = get_user_group
    user_group.present? && ( user_group.admin? || user_group.owner? )
  end

  def add_admin?
    user_group = get_user_group
    user_group.present? && ( user_group.admin? || user_group.owner? )
  end

  def add_member?
    user_group = get_user_group
    user_group.present? && user_group.owner?
  end

  private

  def get_user_group
    group.user_groups.find_by(user_id: user.id)
  end
end
