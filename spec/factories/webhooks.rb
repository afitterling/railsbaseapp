FactoryGirl.define do
  factory :webhook do
    url "http://www.example.com/hook.json"
    device
  end
end
