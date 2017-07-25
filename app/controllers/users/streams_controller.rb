class Users::StreamsController < ApplicationController
  before_action :require_user_access_token
  before_action :assign_device, only: :update
  before_action :ensure_authorized_user, only: :update

  KEYS_COUNT = 10

  def index
    @devices = current_user.devices.order(id: :desc).paginate(page: params[:page], per_page: params[:limit])
    render json: @devices.reverse
  end

  def create
    @device = current_user.devices.build(device_params)
    if @device.key_rotation_enabled.nil?
      @device.key_rotation_enabled = SystemConfig.enable_key_rotation?
    end

    if @device.save
      @tokens = (0...KEYS_COUNT).map do |sequence|
        @device.device_access_tokens.create(sequence: sequence)
      end

      render json: {
        access_tokens: @tokens,
        device: @device
      }
    else
      render json: {errors: @device.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    if @device.update(device_params)
      render json: @device
    else
      render json: {errors: @device.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def device_params
    params.permit(:name, :key_rotation_enabled, :linked, :stream_type, :description)
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
