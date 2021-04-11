Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' ,confirmations: 'confirmations'}

  namespace :api do
    namespace :v1 do
      post :auth, to: 'authentication#login'  
      post 'logout', to: 'authentication#logout'

      resources :posts, only: [:index, :update, :show] 
      get 'post/:id/comments', to: 'posts#comments'

      post 'post/:post_id/comment', to: 'comments#create'
      post 'comment/:id/accept',  to:  'comments#accept'

      post 'group/:id/post', to: 'group_posts#create'
      get 'group/:id/post', to: 'group_posts#posts'
      
      post 'user/post', to: 'user_posts#create'
      get 'user/post', to: 'user_posts#posts'
      get  'user/bookmark_post', to: 'user_posts#bookmarked_post'
      get 'user/:id/public-post', to: 'user_posts#public_posts'
      
      get 'post/:post_id/vote_status', to: 'post_votes#status'
      post 'post/:post_id/upvote', to: 'post_votes#upvote'
      post 'post/:post_id/downvote', to: 'post_votes#downvote'

      get 'comment/:comment_id/vote_status', to: 'comment_votes#status'
      post 'comment/:comment_id/upvote', to: 'comment_votes#upvote'
      post 'comment/:comment_id/downvote', to: 'comment_votes#downvote'

      get 'post/:post_id/bookmark_status', to: 'bookmarks#status'
      post 'post/:post_id/bookmark', to: 'bookmarks#bookmark'
      delete  'bookmark/:id', to: 'bookmarks#delete'
      post 'comment/:comment_id/reply', to: 'reply#create'

      resources :tags, only: [:create, :index] 
      get 'tag/:id/post/public', to: 'tags#general' 
      
      resources :group, only: %i[create index update show] do
        get 'users', on: :member
      end
      post 'group/:id/member', to: 'group#add_member'
      post 'group/:id/admin', to: 'group#add_admin'

      #routes for user_group
      post 'group/:id/user', to: 'user_group#create'
      delete 'group/:id/user/:user_id', to: 'user_group#destroy'
      patch 'group/:id/demote-admin', to: 'user_group#demote_admin'
      get 'group/:id/user-suggestions', to: 'user_group#user_suggestions'

      resources :users, only: %i[index]
      patch :user, to: 'users#update'
      get :user, to: 'users#show'
      get 'user/groups', to: 'users#groups'
      get 'user/:id', to: 'users#user_details'
    end
    namespace :v2 do
      # Things yet to come
    end
  end
end
