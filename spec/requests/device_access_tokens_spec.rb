require 'rails_helper'

RSpec.describe "DeviceAccessTokens", type: :request do
  before(:each) do
    @user = create(:user)
    @device = create(:device, user: @user)
    @device_access_token = create(:device_access_token, device: @device)
    @access_token = create(:access_token, user: @user)
    @read_only_access_token = create(:access_token, user: @user, read_only: true)
  end

  describe "GET /devices/:id/device_access_tokens" do
    it 'should return the access tokens for the specified devices' do
      get "/devices/#{@device.id}/device_access_tokens.json", nil, "X-Access-Token" => @access_token.token
      expect(response).to have_http_status(:ok)

      expect(json_body.length).to eq 1
      expect(json_body[0]["token"]).to eq @device_access_token.token
    end

    it 'should not return the access tokens with read-only token' do
      get "/devices/#{@device.id}/device_access_tokens.json", nil, "X-Access-Token" => @read_only_access_token.token
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
