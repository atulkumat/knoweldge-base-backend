module Api
  module V1
    class GroupController < ApiController
      include UserFilter, GroupFilter
      
      before_action :authenticate_user!
      before_action :set_group, except: %i[create index]
      before_action :find_user, only: %i[add_admin]

      def create
        begin
          Group.transaction do
            group = Group.create!(group_create_params)
            group.user_groups.create!(user_id: current_user.id, role: :owner)

            if params[:users].present?
              params[:users].each do |user_id|
                user = group.user_groups.create!(user_id: user_id, role: :member)
              end
              GroupMailer.new_member_added(params[:users], group).deliver_later
            end
            created_response(group)
          end
        rescue => exception
          bad_request_response(exception)
        end
      end

      def show 
        user_role = @group.user_groups.find_by(user_id: current_user.id)
        response = { group: @group, user_role: user_role&.role }
        success_response(response)
      end

      def index
        groups = Group.order(created_at: :desc)
        groups = filter_by_group_name(groups, params[:name])
        length = groups.length
        groups = pagination(groups, params[:per_page], params[:page_no])
        response = { groups: groups , length: length }
        success_response(response)
      end

      def update
        authorize @group

        if @group.update(group_update_params)
          success_response(@group)
        else
          bad_request_response(@group.errors)
        end
      end

      def add_member
        authorize @group
        
        begin
          Group.transaction do
            if params[:users].present?
              params[:users].each do |user_id|
                @group.user_groups.create(user_id: user_id, role: :member)
              end
              GroupMailer.new_member_added(params[:users], @group).deliver_later
            end
            success_response(@group.user_groups)
          end
        rescue => exception
          bad_request_response(exception)
        end
      end

      def add_admin
        authorize @group
        
        group_record =  @user.user_groups.find_by(group_id: params[:id])

        unless group_record&.member?
          forbidden_response(t('group.role_should_be_member'))
        end

        if group_record.update(role: :admin)
          GroupMailer.promoted_to_admin(@user, @group).deliver_later
          success_response(group_record)
        else
          bad_request_response(group_record.errors)
        end
      end
      
      def users
        users = @group.user_groups.joins(:user).order(:role, :status)
        users = filter_by_username(users, params[:name])
        length = users.length
        users = pagination(users, params[:per_page], params[:page_no])
        render json: users, record_count: length, status: 200
      end

      private

        def group_create_params
          params.require(:group).permit(:description, :name, :users)
        end

        def group_update_params
          params.require(:group).permit(:description)
        end
  
        def find_user
          @user = User.find_by_id(params[:user_id])
          
          return record_not_found_response unless @user.present?
        end

        def set_group
          @group = Group.find_by(id: params[:id])

          return record_not_found_response unless @group.present?
        end
    end
  end   
end
