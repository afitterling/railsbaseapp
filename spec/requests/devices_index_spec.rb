require 'rails_helper'

RSpec.describe "DevicesIndex", type: :request do
  before(:each) do
    @user = create(:user)
    @access_token = create(:access_token, user: @user)
    @devices = 5.times.map { create(:device, user: @user) }
    @other_device = create(:device)
  end

  paths = ["/devices", "/streams", "/users/streams"]

  paths.each do |path|
    describe "GET #{path}" do
      it 'should list all devices' do
        get "#{path}.json", nil, "X-Access-Token" => @access_token.token
        expect(response).to have_http_status(:ok)
        expect(json_body.count).to eq @user.devices.count

        has_other_device = json_body.any? { |dev| dev["id"] == @other_device.id }
        expect(has_other_device).not_to be true
      end

      it 'should require access token' do
        get "#{path}.json"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
