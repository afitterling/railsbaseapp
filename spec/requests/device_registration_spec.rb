require 'rails_helper'

RSpec.describe "DeviceRegistration", type: :request do
  before(:each) do
    @user = create(:user)
    @access_token = create(:access_token, user: @user)
  end

  paths = ["/devices", "/streams", "/users/streams"]

  paths.each do |path|
    describe "POST #{path}" do
      it 'should create the specified device' do
        expect do
          post "#{path}.json", {key_rotation_enabled: false, name: 'yay'}, "X-Access-Token" => @access_token.token
          expect(response).to have_http_status(:ok)
        end.to change { Device.count }.by(1)

        device = Device.find(json_body["device"]["id"])
        expect(device.key_rotation_enabled?).to eq false
        expect(device.name).to eq 'yay'

        expect do
          post "#{path}.json", {key_rotation_enabled: true, name: 'foo'}, "X-Access-Token" => @access_token.token
          expect(response).to have_http_status(:ok)
        end.to change { Device.count }.by(1)

        device = Device.find(json_body["device"]["id"])
        expect(device.key_rotation_enabled?).to eq true
        expect(device.name).to eq 'foo'
      end

      it 'should use the global default key rotation setting' do
        expect do
          post "#{path}.json", nil, "X-Access-Token" => @access_token.token
          expect(response).to have_http_status(:ok)
        end.to change { Device.count }.by(1)

        device = Device.find(json_body["device"]["id"])
        expect(device.key_rotation_enabled?).to eq SystemConfig.enable_key_rotation?

        SystemConfig.key_rotation = (!SystemConfig.enable_key_rotation?).to_s

        expect do
          post "#{path}.json", nil, "X-Access-Token" => @access_token.token
          expect(response).to have_http_status(:ok)
        end.to change { Device.count }.by(1)

        device = Device.find(json_body["device"]["id"])
        expect(device.key_rotation_enabled?).to eq SystemConfig.enable_key_rotation?
      end

      it 'should not create without a valid user access token' do
        expect do
          post "#{path}.json"
        end.not_to change { Device.count }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
