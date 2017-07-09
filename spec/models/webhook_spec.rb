require 'rails_helper'

RSpec.describe Webhook, type: :model do
  before(:each) do
    @webhook = create(:webhook)
  end

  describe "default factory object" do
    it "should be valid" do
      expect(@webhook).to be_valid
    end
  end

  describe "url" do
    it "should be present" do
      @webhook.url = ''
      expect(@webhook).not_to be_valid
    end
  end

  describe "device" do
    it "should be present" do
      @webhook.device = nil
      expect(@webhook).not_to be_valid
    end
  end
end
