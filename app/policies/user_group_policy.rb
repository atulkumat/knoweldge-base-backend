class UserGroupPolicy
  attr_reader :user, :user_group

  def initialize(user, user_group)
    @user = user
    @user_group = user_group
  end

  def demote_admin?
    user_record = get_user_record
    user_record.present? && user_record.owner?
  end

  def destroy?
    user_record = get_user_record
    user_record.present?
  end

  private 
    def get_user_record
      UserGroup.find_by(user_id: user.id, group_id: user_group.group_id)
    end
end
