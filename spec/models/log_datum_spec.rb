require 'rails_helper'

RSpec.describe LogDatum, type: :model do
  before(:each) do
    @log_datum = create(:log_datum)
  end

  describe "default factory object" do
    it "should be valid" do
      expect(@log_datum).to be_valid
    end
  end

  describe "images" do
    it "should be accessible through the accessor" do
      expect(@log_datum).to respond_to(:images)
    end

    it "should be destroyed when log datum is destroyed" do
      5.times { create(:image, log_datum: @log_datum) }
      expect(@log_datum.images).not_to be_empty

      expect do
        @log_datum.destroy
      end.to change { Image.count }.by(-@log_datum.images.count)
    end
  end
end
