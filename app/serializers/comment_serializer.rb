class CommentSerializer <  ApplicationSerializer
  attributes :content, :upvotes, :downvotes, :id, :accepted, :created_at, :status 
  belongs_to :user
  has_many :replies

  def status
    if @instance_options[:user].present?
      record = @instance_options[:user]
              .comment_votes.find_by(comment_id: object.id)
              
      if record.present?
        record.status
      end
    end
  end

end
