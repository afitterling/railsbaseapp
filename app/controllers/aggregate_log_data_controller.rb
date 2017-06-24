class AggregateLogDataController < ApplicationController
  before_action :require_user_access_token

  def index
    @devices = current_user.devices.where(id: device_ids)
    @log_data = LogDatum.where(device: @devices)

    response_hash = @log_data.reduce({}) do |hash, log_datum|
      arr = hash.fetch(log_datum.device_id, [])
      arr << log_datum
      hash[log_datum.device_id] = arr
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
