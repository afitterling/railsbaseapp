class Users::StreamsController < ApplicationController
  before_action :require_user_access_token

  KEYS_COUNT = 10

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

  private

  def device_params
    params.permit(:name, :key_rotation_enabled)
  end
end
