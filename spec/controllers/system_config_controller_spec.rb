require 'rails_helper'

RSpec.describe SystemConfigController, type: :controller do
  before(:each) do
    @user = create(:user)
    @access_token = create(:access_token, user: @user)
  end

  describe 'show' do
    it 'should do return the current config for the given key' do
      request.headers.merge!("X-Access-Token" => @access_token.token)
      get :show, { key: "key_rotation" }
      expect(response).to have_http_status(:ok)
      expect(json_body).to have_key("key_rotation")
      expect(json_body["key_rotation"]).to eq SystemConfig["key_rotation"]

      SystemConfig["key_rotation"] = "hello world"
      request.headers.merge!("X-Access-Token" => @access_token.token)
      get :show, { key: "key_rotation" }
      expect(response).to have_http_status(:ok)
      expect(json_body).to have_key("key_rotation")
      expect(json_body["key_rotation"]).to eq SystemConfig["key_rotation"]
    end
  end

  describe 'update' do
    it 'should update the specified config' do
      request.headers.merge!("X-Access-Token" => @access_token.token)
      post :update, { key: "key_rotation", value: "foobar123" }
      expect(response).to have_http_status(:ok)
      expect(json_body).to have_key("key_rotation")
      expect(json_body["key_rotation"]).to eq SystemConfig["key_rotation"]
      expect(SystemConfig["key_rotation"]).to eq "foobar123"
    end
  end
end
