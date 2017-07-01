FactoryGirl.define do
  factory :log_datum do
    device
    payload {{hello: "world"}}
  end
end
