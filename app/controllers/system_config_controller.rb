class SystemConfigController < ApplicationController
  before_action :require_read_write_user_access_token

  def show
    render json: {params[:key] => SystemConfig[params[:key]]}
  end

  def update
    SystemConfig[params[:key]] = params[:value]
    render json: {params[:key] => SystemConfig[params[:key]]}
  end
end
