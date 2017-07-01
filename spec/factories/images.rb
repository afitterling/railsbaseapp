include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :image do
    image { fixture_file_upload(Rails.root.join('spec', 'image.png'), 'image/png') }
    log_datum
  end
end
