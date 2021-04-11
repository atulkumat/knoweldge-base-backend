class RegistrationsController < Devise::RegistrationsController
  respond_to :json 

  def create
    @user = User.new(sign_up_params)
    if @user.save
      render json: { message: t('confirm_email')}, status: 201
    else
      render json: { errors: @user.errors }, status: 400
    end
  end

  private

  def sign_up_params
    params.permit(:email, :password, :first_name, :last_name, :dob, :gender)
  end
end
