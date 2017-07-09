require 'rails_helper'

RSpec.describe "WebhooksIndex", type: :request do
  before(:each) do
    @user = create(:user)
    @access_token = create(:access_token, user: @user)

    @device = create(:device, user: @user)
    @webhooks = 5.times.map { create(:webhook, device: @device) }

    @other_device = create(:device)
    @other_webhook = create(:webhook, device: @other_device)
  end

  describe "GET /users/webhooks" do
    it "should list all webhooks" do
      get "/users/webhooks", nil, "X-Access-Token" => @access_token.token
      expect(response).to have_http_status(:ok)
      expect(json_body.count).to eq @webhooks.count

      response_ids = json_body.map { |x| x["id"] }
      @webhooks.map(&:id).each do |id|
        expect(response_ids).to include id
      end
    end

    it "should require user access token" do
      get "/users/webhooks"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
