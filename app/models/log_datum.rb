class LogDatum < ActiveRecord::Base
  belongs_to :device
  has_many :images, dependent: :destroy
end
