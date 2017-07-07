class AggregateLogDataController < ApplicationController
  before_action :require_user_access_token

  def index
    @devices = current_user.devices.where(id: device_ids)

    response_hash = @devices.reduce({}) do |hash, device|
      hash[device.id] = device.log_data.order(id: :desc).paginate(page: params[:page], per_page: params[:limit])
      hash
    end

    render json: response_hash
  end

  private

  def device_ids
    return @device_ids if @device_ids

    begin
      @device_ids = JSON.parse(params[:device_ids])
    rescue
      @device_ids = []
    end
  end
end
