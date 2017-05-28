class DeviceAccessToken < ActiveRecord::Base
  belongs_to :device

  after_initialize do |access_token|
    access_token.token = SecureRandom.uuid unless access_token.token
  end

  def consume
    device.last_used_key_sequence = sequence
    device.save
  end
end
