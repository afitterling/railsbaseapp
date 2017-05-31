FactoryGirl.define do
  factory :device_access_token do
    sequence(:token) { |n| "token-#{n}" }
    device
  end
end
