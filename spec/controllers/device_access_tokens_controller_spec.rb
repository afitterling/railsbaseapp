require 'rails_helper'

RSpec.describe DeviceAccessTokensController, type: :controller do
  before(:each) do
    @user = create(:user)
    @access_token = create(:access_token, user: @user)
  end

  describe 'index' do
    it 'should return all access tokens for the specified device' do
      device = create(:device, user: @user)
      5.times { create(:device_access_token, device: device) }
      request.headers.merge!("X-Access-Token" => @access_token.token)
      get :index, device_id: device.id
      expect(response).to have_http_status(:ok)
      expect(json_body.count).to eq device.device_access_tokens.count
    end

    it "should not return another user's device access tokens" do
      device = create(:device)
      5.times { create(:device_access_token) }
      request.headers.merge!("X-Access-Token" => @access_token.token)
      get :index, device_id: device.id
      expect(response).to have_http_status(:forbidden)
    end

    it "should require user access token" do
      device = create(:device)
      get :index, device_id: device.id
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
