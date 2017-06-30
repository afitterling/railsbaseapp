class DevicesController < ApplicationController
  before_action :require_user_access_token
  before_action :assign_device, only: :update
  before_action :ensure_authorized_user, only: :update

  KEYS_COUNT = 10

  def update
    if @device.update(device_params)
      render json: @device
    else
      render json: {errors: @device.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def device_params
    params.permit(:name, :key_rotation_enabled)
  end

  def assign_device
    @device = Device.find(params[:id])
  end

  def ensure_authorized_user
    unless @device.user == current_user
      render json: {errors: ["Not allowed to access this device"]}, status: :forbidden
    end
  end
end
