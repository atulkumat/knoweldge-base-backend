module Api
  module V1
    class UserPostsController < ApiController
      before_action :authenticate_user!, except: :public_posts
      
      def posts
        posts = current_user.posts
        posts = filter(posts)
        posts = order(posts)
        length = posts.length
        posts = pagination(posts, params[:per_page], params[:page_no])
        render json: posts, record_count: length, user: current_user, status: 200 
      end 
      
      def bookmarked_post
        posts = Post.joins(:bookmarks).where(user_id: current_user.id)
        posts = filter(posts)
        posts = order(posts)
        length = posts.length 
        posts = pagination(posts, params[:per_page], params[:page_no])
        render json: posts, record_count: length, user: current_user, status: 200 
      end 
      
      def public_posts
        posts = User.find_by(id: params[:id]).posts.general
        success_response(posts)
      end

      def create 
        begin
          Post.transaction do
            post = current_user.posts.new(post_create_params)
            post.save!  

            if params[:tags].present?
              post.post_tags.create!(params[:tags].map { |tag| 
                                     { tag_id: Tag.find_by(name: params[:tags]).id } } )  
            end  
            created_response(post)
          end
        rescue => exception
          bad_request_response({ error: exception })
        end  
      end

      private 

      def filter(posts) 
        if params[:tag].present?
          tag = Tag.find_by(name: params[:tag])
          if tag
            posts = posts.joins(:tags).where(tags: {id: tag.id })
          else 
            return Post.none  
          end
        end  

        if params[:title].present?
          posts = posts.where('lower(title) like ?', 
                                "%#{params[:title].downcase}%")  
        end  
        posts 
      end   

      def order(posts)
        if params[:sort].present? && params[:sort] == 'asc'  
          posts = posts.order(created_at: :asc)
        else     
          posts = posts.order(created_at: :desc) 
        end 
        posts
      end
      
      def post_create_params 
        params.permit(:title, :description, :visibility)
      end
    end 
  end 
end
