class DeviceAccessTokensController < ApplicationController
  before_action :require_user_access_token
  before_action :assign_device

  def index
    render json: @device.device_access_tokens
  end

  private

  def assign_device
    @device = current_user.devices.find_by(id: params[:device_id])
    render json: {errors: ["Device ID not found"]}, status: :forbidden unless @device
  end
end
