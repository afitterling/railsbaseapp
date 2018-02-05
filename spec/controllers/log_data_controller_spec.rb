require 'rails_helper'

RSpec.describe LogDataController, type: :controller do
  before(:each) do
    @user = create(:user)

    @device = create(:device, user: @user)
    @access_token = create(:device_access_token, device: @device)

    LogDatum.all.each(&:destroy)
    @log_data = 50.times.map { |i| create(:log_datum, id: i, device: @device) }
  end

  it 'should sort the output' do
    request.headers.merge!("X-Access-Token" => @access_token.token)

    get :index, limit: 10
    expect(response).to have_http_status(:ok)
    expect(json_body.length).to eq 10

    expected_ids = (40..49).to_a
    response_ids = json_body.map { |x| x["id"] }
    expect(response_ids).to eq expected_ids

    expect(response.headers['X-Total-Count']).to eq @device.log_data.count.to_s
  end
end
