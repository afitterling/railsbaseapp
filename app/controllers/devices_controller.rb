class DevicesController < ApplicationController
  before_action :require_user_access_token
  KEYS_COUNT = 10

  def index
    render json: current_user.devices
  end

  def create
    @device = current_user.devices.build(device_parameters)
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

  private

  def device_parameters
    params.permit(:key_rotation_enabled)
  end
end
