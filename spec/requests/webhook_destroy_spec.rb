require 'rails_helper'

RSpec.describe "WebhookDestroy", type: :request do
  describe "DELETE /users/webhooks/:id" do
    before(:each) do
      @webhook      = create(:webhook)
      @device       = @webhook.device
      @user         = @device.user
      @access_token = create(:access_token, user: @user)
    end

    it "should destroy the webhook" do
      expect do
        delete "/users/webhooks/#{@webhook.id}", nil, "X-Access-Token" => @access_token.token
        expect(response).to have_http_status(:no_content)
      end.to change { Webhook.count }.by(-1)

      webhook = Webhook.find_by(id: @webhook.id)
      expect(webhook).to be_nil
    end

    it "should require a user access token" do
      expect do
        delete "/users/webhooks/#{@webhook.id}"
        expect(response).to have_http_status(:unauthorized)
      end.not_to change { Webhook.count }
    end

    it "should not destroy webhook for unauthorized streams" do
      @device.user = create(:user)
      @device.save!

      expect do
        delete "/users/webhooks/#{@webhook.id}", nil, "X-Access-Token" => @access_token.token
        expect(response).to have_http_status(:forbidden)
      end.not_to change { Webhook.count }
    end
  end
end
