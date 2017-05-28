require 'rails_helper'

RSpec.describe DeviceAccessToken, type: :model do
  describe "New object" do
    it "should have a default token" do
      access_token = DeviceAccessToken.new
      expect(access_token).not_to be_nil
    end
  end

  describe "consume" do
    it "should update device last_used_key_sequence" do
      device = Device.create!
      token1 = device.device_access_tokens.create!(sequence: 1)
      token2 = device.device_access_tokens.create!(sequence: 2)

      token1.consume
      device.reload
      expect(device.last_used_key_sequence).to eq token1.sequence

      token2.consume
      device.reload
      expect(device.last_used_key_sequence).to eq token2.sequence
    end
  end
end
