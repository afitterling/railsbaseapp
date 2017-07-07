class Webhook < ActiveRecord::Base
  belongs_to :device

  validates :url, presence: true
end
