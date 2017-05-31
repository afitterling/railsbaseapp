class DevicesController < ApplicationController
  before_action :require_user_access_token
  KEYS_COUNT = 10

  def index
    render json: current_user.devices
  end

  def create
    @device = current_user.devices.create
    @tokens = (0...KEYS_COUNT).map do |sequence|
      @device.device_access_tokens.create(sequence: sequence)
    end

    render json: {
      access_tokens: @tokens,
      device: @device
    }
  end
end
