class ReplySerializer < ApplicationSerializer
  attributes :id, :content, :created_at, :user_id, :user
  
  def user
    { 
      first_name: object.user.first_name,
      last_name: object.user.last_name,
      id: object.user.id 
    }
  end
end
