require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = create(:user)
  end

  describe "default factory object" do
    it "should be valid" do
      expect(@user).to be_valid
    end
  end

  describe "email" do
    it "should not be empty" do
      @user.email = ""
      expect(@user).not_to be_valid
    end

    it "should not be nil" do
      @user.email = nil
      expect(@user).not_to be_valid
    end
  end

  describe "devices" do
    it "should respond to accessor method" do
      expect(@user).to respond_to :devices
    end

    it "should destroy devices when user is destroyed" do
      5.times { create(:device, user: @user) }
      expect do
        @user.destroy
      end.to change { Device.count }.by(-@user.devices.count)
    end
  end
end
