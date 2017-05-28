FactoryGirl.define do
  factory :device_access_token do
    token "MyString"
    sequence 1
    device nil
  end
end
