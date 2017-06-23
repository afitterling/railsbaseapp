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

  describe 'create' do
    it 'should create the specified device' do
      request.headers.merge!("X-Access-Token" => @access_token.token)

      expect do
        post :create, {key_rotation_enabled: false}
        expect(response).to have_http_status(:ok)
      end.to change { Device.count }.by(1)

      device = Device.find(json_body["device"]["id"])
      expect(device.key_rotation_enabled?).to eq false

      expect do
        post :create, {key_rotation_enabled: true}
        expect(response).to have_http_status(:ok)
      end.to change { Device.count }.by(1)

      device = Device.find(json_body["device"]["id"])
      expect(device.key_rotation_enabled?).to eq true
    end

    it 'should use the global default key rotation setting' do
      request.headers.merge!("X-Access-Token" => @access_token.token)

      expect do
        post :create
        expect(response).to have_http_status(:ok)
      end.to change { Device.count }.by(1)

      device = Device.find(json_body["device"]["id"])
      expect(device.key_rotation_enabled?).to eq SystemConfig.enable_key_rotation?

      SystemConfig.key_rotation = (!SystemConfig.enable_key_rotation?).to_s

      expect do
        post :create
        expect(response).to have_http_status(:ok)
      end.to change { Device.count }.by(1)

      device = Device.find(json_body["device"]["id"])
      expect(device.key_rotation_enabled?).to eq SystemConfig.enable_key_rotation?
    end
  end
end
