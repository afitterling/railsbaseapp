class UsersController < ApplicationController
  before_action :require_user_access_token

  def profile
    render json: current_user
  end
end
