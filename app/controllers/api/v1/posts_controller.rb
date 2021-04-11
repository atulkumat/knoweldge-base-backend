module Api
  module V1
    class PostsController < ApiController
      before_action :authenticate_user!, except: [:index, :show, :comments]
      before_action :set_post, only: [:update, :show, :comments]
    
      def index
        posts = Post.general
        posts = filter(posts)
        posts = order(posts)
        length = posts.length
        posts = pagination(posts, params[:per_page], params[:page_no])
        render json: posts, record_count: length, user: current_user, status: 200  
      end
      
      def show 
        authorize @post 
        render json: @post, user: current_user, status:200
      end
      
      def comments
        authorize @post
        comments = @post.comments.order(accepted: :desc, upvotes: :desc)
        render json: comments, user: current_user, status: 200
      end 

      def update 
        authorize @post 

        if @post.update(post_update_params)
          success_response(@post)
        else
          bad_request_response(@post.errors)
        end 
      end 

      private 
      
      def set_post 
        @post = Post.find_by(id: params[:id]) 

        if @post.nil?
          record_not_found_response
        end 
      end

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

      def post_update_params 
        params.permit(:title, :description)
      end 
    end 
  end 
end
