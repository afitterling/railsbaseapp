class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :validatable

  has_many :access_tokens, dependent: :destroy
  has_many :devices, dependent: :destroy
end
