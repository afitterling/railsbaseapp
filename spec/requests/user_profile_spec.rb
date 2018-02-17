require 'rails_helper'

RSpec.describe "UserProfile", type: :request do
  before(:each) do
    @user = create(:user)
    @access_token = create(:access_token, user: @user)
    @read_only_access_token = create(:access_token, user: @user, read_only: true)
  end

  describe "show" do
    it "should respond with unauthorized without a valid access token" do
      get user_profile_path
      expect(response).to have_http_status(:unauthorized)

      fake_token = "walala"
      expect(AccessToken.find_by(token: fake_token)).to eq nil
      get user_profile_path, nil, "X-Access-Token" => fake_token
      expect(response).to have_http_status(:unauthorized)
    end

    it "should respond with unauthorized with a read-only token" do
      get user_profile_path, nil, "X-Access-Token" => @read_only_access_token.token
      expect(response).to have_http_status(:unauthorized)
    end

    it "should respond with a JSON object with the correct keys" do
      get user_profile_path, nil, "X-Access-Token" => @access_token.token
      expect(response).to have_http_status(:ok)

      expect(json_body).to have_key("email")
    end
  end
end
