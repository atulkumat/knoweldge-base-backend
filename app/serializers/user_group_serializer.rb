class UserGroupSerializer < ActiveModel::Serializer
  attributes :role, :length
  belongs_to :user

  def length
    @instance_options[:record_count]
  end
end
