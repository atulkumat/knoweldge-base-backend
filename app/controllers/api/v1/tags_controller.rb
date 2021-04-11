module Api
  module V1
    class TagsController < ApiController 
      before_action :authenticate_user! , except: [:index]
      before_action :set_tag, only: [:general]

        def create   
          tag = Tag.new(tag_params)  
          if tag.save   
            success_response(tag)
          else
            bad_request_response(tag.errors)
          end
        end  

        def index    
          tags = Tag.all
          tags = filter(tags) 
          length = tags.length
          tags = pagination(tags, params[:per_page], params[:page_no])    
          success_response({ tags: tags, length: length }) 
        end    
            
        def general 
          posts = @tag.posts.general
          length = posts.length
          render json: posts, record_count: length, user: current_user, status: 200  
        end 

        private  
        
        def filter(tags)
          if params[:name].present? 
            tags = tags.where('lower(name) like ?', 
                               %(#{params[:name].downcase}%))
          end 
          tags 
        end 
         
        def set_tag  
          @tag = Tag.find_by(id: params[:id])

          if @tag.nil?
            record_not_found_response
          end 
        end 

        def tag_params  
          params.permit(:name)
        end     
    end
  end 
end 
