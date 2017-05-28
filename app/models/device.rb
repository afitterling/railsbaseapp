class Device < ActiveRecord::Base
  has_many :device_access_tokens, dependent: :destroy
  has_many :log_data, dependent: :destroy

  def current_valid_token
    device_access_tokens.where("sequence > ?", last_used_key_sequence).order(:sequence).first ||
      device_access_tokens.order(:sequence).first
  end
end
