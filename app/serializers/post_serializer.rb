class PostSerializer <  ApplicationSerializer
  attributes :title, :description, :upvotes, :downvotes, :id, :visibility, :vote_status, :length,
  :bookmark 
  belongs_to :user
  has_many :tags

  def length
    @instance_options[:record_count]
  end

  def vote_status
    if @instance_options[:user].present?
      record = PostVote.find_by(post_id: object.id, user_id: @instance_options[:user].id)
      if record.present?
        record.status
      end
    end
  end  
  
  def bookmark 
    if @instance_options[:user].present?
      record = Bookmark.find_by(post_id: object.id, user_id: @instance_options[:user].id)
      if record.present?
        record
      end  
    end  
  end  
end
