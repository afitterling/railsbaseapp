require 'rails_helper'

RSpec.describe "User read-only tokens" do
  before(:each) do
    @user = create(:user)
    @access_token = create(:access_token, user: @user, read_only: false)
    @read_only_access_token = create(:access_token, user: @user, read_only: true)

    @other_read_only_access_token = create(:access_token, read_only: true)
  end

  describe "GET /user/access_tokens/read_only" do
    it 'should return the list of read-only access tokens for the user' do
      get "/users/access_token/read_only", nil, "X-Access-Token" => @access_token.token
      expect(response).to have_http_status(:ok)

      expect(json_body.length).to eq 1
      expect(json_body[0]["id"]).to eq @read_only_access_token.id
    end

    it 'should not accept a read-only token' do
      get "/users/access_token/read_only", nil, "X-Access-Token" => @read_only_access_token.token
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
