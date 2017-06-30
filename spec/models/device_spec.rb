require 'rails_helper'

RSpec.describe Device, type: :model do
  before(:each) do
    @device = create(:device)
    @tokens = (0..4).map do |seq|
      @device.device_access_tokens.create!(sequence: seq)
    end
  end

  describe "uuid" do
    it "should be set by default" do
      device = Device.new
      expect(@device.uuid).not_to be_blank
    end

    it "should not override existing uuid when loaded from the database" do
      uuid = @device.uuid
      device = Device.find(@device.id)
      expect(device.uuid).to eq uuid
    end

    it "should be present" do
      @device.uuid = ''
      expect(@device).not_to be_valid
    end

    it "should be unique" do
      other_device = build(:device, uuid: @device.uuid)
      expect(other_device).not_to be_valid
    end
  end

  describe "current_valid_token" do
    it "should return the current valid token" do
      @tokens.each do |token|
        expect(@device.current_valid_token).to eq token
        token.consume
      end
    end

    it "should wrap around" do
      @tokens.last.consume
      expect(@device.current_valid_token).to eq @tokens.first
    end
  end

  describe "device access token" do
    it "should be accessible through accessor" do
      expect(@device).to respond_to :device_access_tokens
    end
  end

  describe "log data" do
    it "should be accessible through log data" do
      expect(@device).to respond_to :log_data
    end
  end

  describe "user" do
    it "should be accessible through accessor" do
      expect(@device).to respond_to :user
    end
  end
end
