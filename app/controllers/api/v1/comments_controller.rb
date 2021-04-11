module Api
  module V1
    class CommentsController < ApiController 
      before_action :set_comment, only: [:accept]  
      before_action :set_post, only: [:create]

      def create
        authorize @post, policy_class: CommentPolicy
        comment = current_user.comments.new(comment_create_params)
        
        if comment.save
          render json: comment, user: current_user, status: 200
          CommentMailer.comment_create(@post, current_user).deliver_later
        else 
          bad_request_response(comment.errors)
        end    
      end  
      
      def accept
        @post = @comment.post
        authorize @post, policy_class: CommentPolicy
        @comment.accepted = :true 
        if @comment.save 
          created_response(@comment)
          CommentMailer.comment_accepted(@comment.user, @comment.post).deliver_later
        else   
          bad_request_response(@comment.errors)
        end   
      end

      private 
      
      def set_comment
        @comment = Comment.find_by(id: params[:id])
        return record_not_found_response if @comment.nil? 
      end

      def set_post
        @post = Post.find_by(id: params[:post_id])  
        return record_not_found_response if @post.nil?  
      end  

      def comment_create_params
        params.permit(:post_id, :content)
      end    
    end
  end 
end 
