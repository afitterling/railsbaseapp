require 'rails_helper'

RSpec.describe Image, type: :model do
  before(:each) do
    @image = create(:image)
  end

  describe "default factory object" do
    it "should be valid" do
      expect(@image).to be_valid
    end
  end

  describe "image" do
    it "should be present" do
      @image.image = nil
      expect(@image).not_to be_valid
    end
  end
end
