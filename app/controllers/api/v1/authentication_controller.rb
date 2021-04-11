class Api::V1::AuthenticationController < ApiController
    skip_before_action :authenticate_user!, only: [:login] 
    before_action :validate_request, except: :logout

    def login
      # return forbidden_response(t('confirm_email')) unless @user.confirmed?
      @user.update(status: :online) 
      render json: { 
        token: JsonWebToken.encode(sub: @user.id),
        user: @user
      }, status:  200
    end

    def logout
      if current_user.update(status: :offline)
        success_response(current_user)
      else
        bad_request_response(current_user.errors)
      end
    end

    private 
    
      def validate_request 
        @user = User.find_by(email: params[:email])

        unless @user&.valid_password?(params[:password])
          render json: { errors: t('invalid_credentials') }, status: 401
        end 
      end  
end
