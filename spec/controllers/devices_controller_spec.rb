require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
  before(:each) do
    @user = create(:user)
    @access_token = create(:access_token, user: @user)
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
