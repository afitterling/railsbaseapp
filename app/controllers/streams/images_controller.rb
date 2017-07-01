class Streams::ImagesController < ApplicationController
  before_action :require_device_access_token
  before_action :assign_log_datum
  before_action :ensure_authorized

  def index
    @images = @log_datum.images

    render json: @images
  end

  def create
    @images = params[:images].map do |image|
      @log_datum.images.create(image: image)
    end

    render json: @images.as_json(methods: :image_url)
  end

  private

  def assign_log_datum
    @log_datum = current_device.log_data.find_by(id: params[:log_datum_id])
  end

  def ensure_authorized
    render json: {errors: ["Log datum ID not found"]}, status: :not_found unless @log_datum
  end
end
