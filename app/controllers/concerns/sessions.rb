module Sessions
  attr_writer :access_token

  def raw_access_token
    request.headers["X-Access-Token"]
  end

  def access_token
    return @access_token if @access_token

    device_access_token = DeviceAccessToken.find_by(token: raw_access_token)
    if device_access_token
      device = device_access_token.device
      unless device.key_rotation_enabled? && device_access_token != device.current_valid_token
        device_access_token.consume
        @access_token = device_access_token
      end
    else
      @access_token = AccessToken.find_by(token: raw_access_token)
    end
  end

  def current_user
    access_token && access_token.respond_to?(:user) && access_token.user
  end

  def current_device
    access_token && access_token.respond_to?(:device) && access_token.device
  end

  def require_read_write_access_token
    return render_no_access_token unless raw_access_token
    return render_invalid_access_token unless access_token
    return render_invalid_access_token if access_token.respond_to?(:read_only?) && access_token.read_only?
  end

  def require_read_write_user_access_token
    return render_no_access_token unless raw_access_token
    return render_invalid_access_token unless current_user
    return render_invalid_access_token if access_token.read_only?
  end

  def require_user_access_token
    return render_no_access_token unless raw_access_token
    return render_invalid_access_token unless current_user
  end

  def require_device_access_token
    return render_no_access_token unless raw_access_token
    return render_invalid_access_token unless current_device
  end

  def render_no_access_token
    render json: {errors: ["X-Access-Token is empty."]}, status: :unauthorized
  end

  def render_invalid_access_token
    render json: {errors: ["X-Access-Token is invalid."]}, status: :unauthorized
  end
end
