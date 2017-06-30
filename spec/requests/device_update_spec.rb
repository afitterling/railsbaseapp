require 'rails_helper'

RSpec.describe "DeviceUpdate", type: :request do
  before(:each) do
    @user = create(:user)
    @access_token = create(:access_token, user: @user)
    @device = create(:device, user: @user)
  end

  paths = ["/devices", "/streams", "/users/streams"]

  paths.each do |path|
    describe "PUT #{path}/:id" do
      it 'should update the specified device' do
        initial_key_rotation_config = @device.key_rotation_enabled?

        put "#{path}/#{@device.id}.json",
            {key_rotation_enabled: !initial_key_rotation_config},
            {"X-Access-Token" => @access_token.token}
        expect(response).to have_http_status(:ok)

        @device.reload
        expect(@device.key_rotation_enabled?).to eq !initial_key_rotation_config
      end

      it 'should not update unpermitted fields' do
        put "#{path}/#{@device.id}.json",
            {user_id: @user.id + 1},
            {"X-Access-Token" => @access_token.token}
        expect(response).to have_http_status(:ok)

        @device.reload
        expect(@device.user_id).to eq @user.id
      end

      it 'should not update the device without a valid access token' do
        initial_key_rotation_config = @device.key_rotation_enabled?

        put "#{path}/#{@device.id}.json",
            {key_rotation_enabled: !initial_key_rotation_config}
        expect(response).to have_http_status(:unauthorized)

        @device.reload
        expect(@device.key_rotation_enabled?).to eq initial_key_rotation_config

        expect(AccessToken.find_by(token: "walalalalala")).to be_nil
        put "#{path}/#{@device.id}.json",
            {key_rotation_enabled: !initial_key_rotation_config},
            {"X-Access-Token" => "walalalalala"}
        expect(response).to have_http_status(:unauthorized)

        @device.reload
        expect(@device.key_rotation_enabled?).to eq initial_key_rotation_config
      end

      it 'should not update unauthorized device' do
        other_user = create(:user)
        @device.user = other_user
        @device.save!

        initial_key_rotation_config = @device.key_rotation_enabled?

        put "#{path}/#{@device.id}.json",
            {key_rotation_enabled: !initial_key_rotation_config},
            {"X-Access-Token" => @access_token.token}

        expect(response).to have_http_status(:forbidden)

        @device.reload
        expect(@device.key_rotation_enabled?).to eq initial_key_rotation_config
      end
    end
  end
end
