class LogDataController < ApplicationController
  before_action :require_device_access_token

  def index
    @log_data = current_device.log_data.order(id: :asc).paginate(page: params[:page], per_page: params[:limit])
    render json: @log_data
  end

  def create
    @log_datum = current_device.log_data.build(payload: params[:payload])

    if @log_datum.save
      render json: @log_datum
    else
      render json: {errors: @log_datum.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def show
    @log_datum = current_device.log_data.find_by(id: params[:id])

    if @log_datum
      render json: @log_datum
    else
      render json: {errors: ["Not found"]}, status: :not_found
    end
  end

  private

  def log_datum_params
    params.require(:log_datum).permit(:payload)
  end
end
