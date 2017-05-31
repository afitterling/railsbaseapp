require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  before(:each) do
    @user = create(:user)
    @access_token = create(:access_token, user: @user)
  end

  describe 'index' do
    it 'should list all devices' do
      other_device = create(:device)
      5.times { create(:device, user: @user) }

      request.headers.merge!("X-Access-Token" => @access_token.token)
      get :index
      expect(response).to have_http_status(:ok)
      expect(json_body.count).to eq @user.devices.count

      has_other_device = json_body.any? { |dev| dev["id"] == other_device.id }
      expect(has_other_device).not_to be true
    end

    it 'should require access token' do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
