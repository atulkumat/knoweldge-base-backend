module Api
  module V1
    class UsersController < ApiController
      include UserFilter, GroupFilter

      before_action :authenticate_user!, except: %i[user_details index]

      def show
        success_response(current_user)
      end

      def user_details
        user = User.find_by(id: params[:id])
        success_response(user)
      end
      
      def index
        users = User.order(:status, created_at: :desc)
        users = filter_by_username(users, params[:name])
        length = users.length
        users = pagination(users, params[:per_page], params[:page_no])
        respone = { users: users , length: length }
        success_response(respone)
      end

      def groups
        groups = current_user.groups.order(created_at: :desc)
        groups = filter_by_group_name(groups, params[:name])
        length = groups.length
        groups = pagination(groups, params[:per_page], params[:page_no])
        respone = { groups: groups , length: length }
        success_response(respone)
      end

      def update
        if current_user.update(user_update_params)
          success_response(current_user)
        else
          bad_request_response(current_user.errors)
        end
      end

      private

        def user_update_params
          params.permit(:first_name, :last_name, :dob, :gender)
        end
    end
  end
end
