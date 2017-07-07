class Device < ActiveRecord::Base
  has_many :device_access_tokens, dependent: :destroy
  has_many :log_data, dependent: :destroy
  belongs_to :user
  has_many :webhooks, dependent: :destroy

  validates :uuid, presence: true, uniqueness: true

  after_initialize do |device|
    device.uuid = SecureRandom.uuid unless device.uuid
  end

  def current_valid_token
    device_access_tokens.where("sequence > ?", last_used_key_sequence).order(:sequence).first ||
      device_access_tokens.order(:sequence).first
  end
end
