class UsersController < ApplicationController
  before_action :require_user_access_token, only: [:profile]

  def create
    user = User.new(user_params)

    if user.save
      UserMailer.welcome_email(user.email).deliver_later

      access_token = user.access_tokens.create
      render json: {
        access_token: access_token,
        user: user
      }
    else
      render json: {errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def profile
    render json: current_user
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end
