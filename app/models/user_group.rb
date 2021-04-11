class UserGroup < ApplicationRecord
  enum role: [:owner, :admin, :member]

  belongs_to :user
  belongs_to :group
  
  validates_presence_of :role
  validates_uniqueness_of :user_id, scope: :group_id
end
