require 'rails_helper'

RSpec.describe "WebhookRegistration", type: :request do
  describe "POST /users/streams/:stream_id/webhooks" do
    before(:each) do
      @device = create(:device)
      @user = @device.user
      @access_token = create(:access_token, user: @user)
    end

    it "should create a webhook with valid params" do
      expect do
        post "/users/streams/#{@device.id}/webhooks",
             {url: "http://example.com/foo.json"},
             {"X-Access-Token" => @access_token.token}
        expect(response).to have_http_status(:ok)
      end.to change { Webhook.count }.by(1)
    end

    it "should not create a webhook without a valid params" do
      expect do
        post "/users/streams/#{@device.id}/webhooks",
             {url: ""},
             {"X-Access-Token" => @access_token.token}
        expect(response).to have_http_status(:unprocessable_entity)
      end.not_to change { Webhook.count }
    end

    it "should require a user access token" do
      expect do
        post "/users/streams/#{@device.id}/webhooks",
             {url: "http://example.com/foo.json"}
        expect(response).to have_http_status(:unauthorized)
      end.not_to change { Webhook.count }
    end

    it "should not create webhook for unauthorized streams" do
      other_user = create(:user)
      @device.user = other_user
      @device.save!

      expect do
        post "/users/streams/#{@device.id}/webhooks",
             {url: "http://example.com/foo.json"},
             {"X-Access-Token" => @access_token.token}
        expect(response).to have_http_status(:forbidden)
      end.not_to change { Webhook.count }
    end
  end
end
