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

  describe 'update' do
    before(:each) do
      @device = create(:device, user: @user)
    end

    it 'should update the specified device' do
      initial_key_rotation_config = @device.key_rotation_enabled?
      request.headers.merge!("X-Access-Token" => @access_token.token)
      put :update, id: @device.id, key_rotation_enabled: !initial_key_rotation_config
      expect(response).to have_http_status(:ok)

      @device.reload
      expect(@device.key_rotation_enabled?).to eq !initial_key_rotation_config
    end

    it 'should not update unpermitted fields' do
      request.headers.merge!("X-Access-Token" => @access_token.token)
      put :update, id: @device.id, user_id: @user.id + 1
      expect(response).to have_http_status(:ok)

      @device.reload
      expect(@device.user_id).to eq @user.id
    end

    it 'should not update the device without a valid access token' do
      initial_key_rotation_config = @device.key_rotation_enabled?
      put :update, id: @device.id, key_rotation_enabled: !initial_key_rotation_config
      expect(response).to have_http_status(:unauthorized)

      @device.reload
      expect(@device.key_rotation_enabled?).to eq initial_key_rotation_config

      expect(AccessToken.find_by(token: "walalalalala")).to be_nil
      request.headers.merge!("X-Access-Token" => "walalalalala")
      put :update, id: @device.id, key_rotation_enabled: !initial_key_rotation_config
      expect(response).to have_http_status(:unauthorized)

      @device.reload
      expect(@device.key_rotation_enabled?).to eq initial_key_rotation_config
    end

    it 'should not update unauthorized device' do
      other_user = create(:user)
      @device.user = other_user
      @device.save!

      initial_key_rotation_config = @device.key_rotation_enabled?
      request.headers.merge!("X-Access-Token" => @access_token.token)
      put :update, id: @device.id, key_rotation_enabled: !initial_key_rotation_config
      expect(response).to have_http_status(:forbidden)

      @device.reload
      expect(@device.key_rotation_enabled?).to eq initial_key_rotation_config
    end
  end
end
