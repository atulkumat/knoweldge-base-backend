class BookmarkPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end
  
  def bookmark?
    @record.general? || UserGroup.where(user_id: user.id, group_id: @record.groups).exists?
  end

  def delete?
    @record.user_id == user.id 
  end   
end
