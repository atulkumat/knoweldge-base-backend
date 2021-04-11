module Api
  module V1
    class UserGroupController < ApiController
      include UserFilter
      
      before_action :authenticate_user!
      before_action :set_group, except: :destroy
      before_action :set_user, only: %i[destroy demote_admin]
      before_action :set_user_group, only: %i[destroy demote_admin]

      def create 
        user_group = UserGroup.new(group_id: params[:id],
                    user_id: current_user.id, role: :member)
  
        if user_group.save
          success_response(user_group.group)
        else
          bad_request_response(user_group.errors)
        end
      end

      def destroy
        authorize @user_group

        begin
          UserGroup.transaction do
            if @user_group.owner?
              @user_group.destroy!
              new_owner = UserGroup.where(group_id: params[:id]).order(:role).first
              
              unless new_owner.present?
                Group.find_by(id: params[:id]).destroy!
                return success_response(@user_group)
              end
              new_owner = new_owner.update!(role: :owner)
            else
              @user_group.destroy!
            end
            success_response(@user_group)
          end
        rescue => exception
          bad_request_response(exception)
        end
      end

      def demote_admin
        authorize @user_group
        
        if @user_group.update(role: :member)
          GroupMailer.demote_to_member(@user, @group).deliver_later
          success_response(@user_group)
        else
          bad_request_response(@user_group.errors)
        end
      end

      def user_suggestions
        users = UserGroup.where(group_id: params[:id]).pluck(:user_id)
        suggestions = User.where.not(id: users)
        suggestions = filter_by_username(suggestions, params[:name])
        success_response(suggestions)
      end

      private 

        def set_group
          @group = Group.find_by(id: params[:id])

          return record_not_found_response unless @group.present?
        end

        def set_user
          @user = User.find_by(id: params[:user_id])

          return record_not_found_response unless @user.present?
        end

        def set_user_group
          @user_group = UserGroup.find_by(group_id: params[:id], user_id: params[:user_id])
          
          return record_not_found_response unless @user_group.present?
        end
    end
  end
end
