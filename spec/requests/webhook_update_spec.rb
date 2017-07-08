require 'rails_helper'

RSpec.describe "WebhookRegistration", type: :request do
  describe "POST /users/streams/:stream_id/webhooks" do
    before(:each) do
      @device = create(:device)
      @user = @device.user
      @access_token = create(:access_token, user: @user)
      @webhook = create(:webhook, device: @device)
    end

    it "should update the webhook with valid params" do
      put "/users/webhooks/#{@webhook.id}.json",
          {url: "http://yay.com/webhook.json"},
          {"X-Access-Token" => @access_token.token}
      expect(response).to have_http_status(:ok)

      @webhook.reload
      expect(@webhook.url).to eq "http://yay.com/webhook.json"
    end

    it "should not update with invalid params" do
      url = @webhook.url
      put "/users/webhooks/#{@webhook.id}.json",
          {url: ""},
          {"X-Access-Token" => @access_token.token}
      expect(response).to have_http_status(:unprocessable_entity)

      @webhook.reload
      expect(@webhook.url).to eq url
    end

    it "should require user access token" do
      url = @webhook.url
      put "/users/webhooks/#{@webhook.id}.json",
          {url: "http://yay.com/webhook.json"}
      expect(response).to have_http_status(:unauthorized)

      @webhook.reload
      expect(@webhook.url).to eq url
    end

    it "should not update unauthorized webhooks" do
      other_device = create(:device)
      @webhook.device = other_device
      @webhook.save!

      url = @webhook.url
      put "/users/webhooks/#{@webhook.id}.json",
          {url: "http://yay.com/webhook.json"},
          {"X-Access-Token" => @access_token.token}
      expect(response).to have_http_status(:forbidden)

      @webhook.reload
      expect(@webhook.url).to eq url
    end
  end
end
