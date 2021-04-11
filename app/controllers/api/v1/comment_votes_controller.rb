module Api
  module V1
    class CommentVotesController < ApiController 
      before_action :set_comment, :set_vote_entry
      
      def status
        success_response(@comment_vote)
      end

      def upvote 
        authorize @comment, policy_class: CommentVotePolicy
        return forbidden_response({ errors: t('already_upvoted') }) if @comment_vote&.upvote?
        response, success = @comment.up_vote(@comment_vote, current_user.id, params[:comment_id])

        if success
          success_response(response) 
          if current_user != @comment.user
            CommentMailer.up_voted(@comment.user, @comment, current_user).deliver_later
          end  
        else 
          bad_request_response(response)
        end 
      end
      
      def downvote  
        authorize @comment, policy_class: CommentVotePolicy 
        return forbidden_response({ errors: t('already_downvoted') }) if @comment_vote&.downvote?
        response, success = @comment.down_vote(@comment_vote, current_user.id, params[:comment_id])

        if success
          success_response(response) 
          if current_user != @comment.user
            CommentMailer.down_voted(@comment.user, @comment, current_user).deliver_later
          end  
        else 
          bad_request_response(response)
        end 
      end
            
      private 
       
      def set_comment
        @comment = Comment.find_by(id: params[:comment_id])  
        return record_not_found_response if @comment.nil?  
      end  

      def set_vote_entry
        @comment_vote = CommentVote.find_by(comment_id: params[:comment_id],
                                       user_id: current_user.id)
      end   
    end
  end
end
