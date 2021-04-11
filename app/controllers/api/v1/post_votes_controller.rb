module Api
  module V1
    class PostVotesController < ApiController 
      before_action :set_post, :set_vote_entry
      
      def status
        success_response(@vote_entry)
      end

      def upvote
        authorize @post, policy_class: PostVotePolicy
        return forbidden_response({ errors: t('already_upvoted') }) if @vote_entry&.upvote?
        response, success = @post.up_vote(@vote_entry, current_user.id, params[:post_id])

        if success
          success_response(response) 
          if current_user !=  @post.user
            PostVoteMailer.up_voted(@post.user, @post, current_user).deliver_later
          end  
        else 
          bad_request_response(response)
        end 
      end
      
      def downvote  
        authorize @post, policy_class: PostVotePolicy 
        return forbidden_response({ errors: t('already_downvoted') }) if @vote_entry&.downvote? 
        response, success = @post.down_vote(@vote_entry, current_user.id, params[:post_id])

        if success
          success_response(response) 
          if current_user !=  @post.user
            PostVoteMailer.down_voted(@post.user, @post, current_user).deliver_later
          end
        else 
          bad_request_response(response)
        end 
      end
            
      private 
       
      def set_post
        @post = Post.find_by(id: params[:post_id])  
        return record_not_found_response if @post.nil?  
      end  

      def set_vote_entry
        @vote_entry = PostVote.find_by(post_id: params[:post_id],
                                       user_id: current_user.id)
      end    
    end
  end
end       
