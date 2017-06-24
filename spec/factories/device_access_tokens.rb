FactoryGirl.define do
  factory :device_access_token do
    sequence(:token) { |n| "token-#{n}" }
    add_attribute(:sequence) { 0 }
    device
  end
end
