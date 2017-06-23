require 'rails_helper'

RSpec.describe "KeyRotation", type: :request do
  before(:each) do
    @device = create(:device)
    @device_access_tokens = (0...10).map do |i|
      create(:device_access_token, device: @device, sequence: i)
    end
  end

  describe "enabled" do
    before(:each) do
      @device.key_rotation_enabled = true
      @device.save!
    end

    it "should increment the device last_used_key_sequence" do
      token = @device_access_tokens.first
      expect(@device.last_used_key_sequence).to eq -1
      get "/log_data", nil, "X-Access-Token" => token.token
      expect(response).to have_http_status(:ok)
      @device.reload
      expect(@device.last_used_key_sequence).to eq token.sequence
    end

    it "should reject the wrong keys" do
      token = @device_access_tokens.first

      get "/log_data", nil, "X-Access-Token" => token.token
      expect(response).to have_http_status(:ok)
      @device.reload
      expect(@device.last_used_key_sequence).to eq token.sequence

      get "/log_data", nil, "X-Access-Token" => token.token
      expect(response).to have_http_status(:unauthorized)
      @device.reload
      expect(@device.last_used_key_sequence).to eq token.sequence

      token = @device_access_tokens.second

      get "/log_data", nil, "X-Access-Token" => token.token
      expect(response).to have_http_status(:ok)
      @device.reload
      expect(@device.last_used_key_sequence).to eq token.sequence
    end
  end

  describe "disabled" do
    before(:each) do
      @device.key_rotation_enabled = false
      @device.save!
    end

    it "should accept any key" do
      token = @device_access_tokens.first

      get "/log_data", nil, "X-Access-Token" => token.token
      expect(response).to have_http_status(:ok)
      @device.reload
      expect(@device.last_used_key_sequence).to eq token.sequence

      get "/log_data", nil, "X-Access-Token" => token.token
      expect(response).to have_http_status(:ok)
      @device.reload
      expect(@device.last_used_key_sequence).to eq token.sequence

      token = @device_access_tokens.last

      get "/log_data", nil, "X-Access-Token" => token.token
      expect(response).to have_http_status(:ok)
      @device.reload
      expect(@device.last_used_key_sequence).to eq token.sequence
    end
  end
end
