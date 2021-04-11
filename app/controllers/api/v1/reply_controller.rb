module Api
  module V1
    class ReplyController < ApiController
      before_action :authenticate_user!
      before_action :validate_comment

      def create
        reply = Reply.new(reply_create_params)
        reply.user_id = current_user.id
        if reply.save
          success_response(reply)
        else
          bad_request_response(reply.errors)
        end
      end

      private 

        def reply_create_params
          params.permit(:comment_id, :content)
        end

        def validate_comment
          @comment = Comment.find_by(id: params[:comment_id])
          
          return record_not_found_response unless @comment.present?
        end
    end    
  end
end
