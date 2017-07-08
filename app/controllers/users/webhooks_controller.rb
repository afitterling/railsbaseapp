class Users::WebhooksController < ApplicationController
  before_action :require_user_access_token
  before_action :assign_device, only: [:create]
  before_action :assign_webhook, only: [:update]

  def create
    @webhook = @device.webhooks.build(webhook_params)

    if @webhook.save
      render json: @webhook
    else
      render json: {errors: @webhook.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    if @webhook.update(webhook_params)
      render json: @webhook
    else
      render json: {errors: @webhook.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def webhook_params
    params.require(:webhook).permit(:url, :active)
  end

  def assign_device
    @device = current_user.devices.find_by(id: params[:stream_id])
    render json: {errors: ["Device ID not found"]}, status: :forbidden unless @device
  end

  def assign_webhook
    @webhook = Webhook.find_by(id: params[:id])

    unless @webhook && @webhook.device.user == current_user
      render json: {errors: ["Webhook ID not found"]}, status: :forbidden
    end
  end
end
