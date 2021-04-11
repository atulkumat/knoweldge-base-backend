module Api
  module V1
    class BookmarksController < ApiController 
      before_action :set_post,only: [:bookmark, :status]
      before_action :set_bookmark_entry, only: [:delete, :status]

      def status
        success_response(@bookmark_entry)
      end  

      def bookmark
        authorize @post, policy_class: BookmarkPolicy 
        return forbidden_response({ errors: 'already bookmarked' }) if @bookmark_entry
        bookmark = current_user.bookmarks.new(bookmark_params)
        
        if bookmark.save
          success_response(bookmark)
        else    
          bad_request_response(bookmark.errors)
        end   
      end 

      def delete
        authorize @bookmark_entry, policy_class: BookmarkPolicy 
        @bookmark_entry.destroy
        head 200
      end  

      private
      
      def set_post
        @post = Post.find_by(id: params[:post_id])
       if @post.nil?
        return record_not_found_response 
       end  
      end   
      
      def bookmark_params
        params.permit(:note, :post_id)
      end 

      def set_bookmark_entry
        if params[:post_id].present?
          @bookmark_entry = Bookmark.find_by(user_id: current_user.id,
                                           post_id: params[:post_id]);
        else 
          @bookmark_entry = Bookmark.find_by(id: params[:id])
        end                                   
      end
    end
  end
end
