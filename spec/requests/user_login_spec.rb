require 'rails_helper'

RSpec.describe "UserLogin", type: :request do
  before(:each) do
    @user = create(:user)
  end

  paths = ["/users/sign_in", "/users/access_token"]

  paths.each do |path|
    describe "POST #{path}" do
      it "should return 200 if email and password are valid" do
        expect do
          post "#{path}.json", email: @user.email, password: "foobar123"
          expect(response).to have_http_status(200)
        end.to change { @user.access_tokens.count }.by(1)
      end

      it "should return 403 if email is malformed" do
        expect do
          post "#{path}.json", email: "wat_is_this", password: "foobar123"
          expect(response).to have_http_status(403)
        end.not_to change { @user.access_tokens.count }
      end

      it "should return 403 if email is not provided" do
        expect do
          post "#{path}.json", password: "foobar123"
          expect(response).to have_http_status(403)
        end.not_to change { @user.access_tokens.count }
      end

      it "should return 403 if email is not found" do
        expect do
          post "#{path}.json", email: "walala@example.com", password: "foobar123"
          expect(response).to have_http_status(403)
        end.not_to change { @user.access_tokens.count }
      end

      it "should return 403 if password is invalid" do
        expect do
          post "#{path}.json", email: @user.email, password: "hello_there"
          expect(response).to have_http_status(403)
        end.not_to change { @user.access_tokens.count }
      end

      it "should return 403 if password is not provided" do
        expect do
          post "#{path}.json", email: @user.email
        end.not_to change { @user.access_tokens.count }
      end
    end
  end
end
