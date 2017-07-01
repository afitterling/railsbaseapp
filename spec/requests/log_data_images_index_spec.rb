require 'rails_helper'

RSpec.describe "LogDataImagesIndex", type: :request do
  before(:each) do
    @device = create(:device)
    @device_access_token = create(:device_access_token, device: @device)

    @log_datum = create(:log_datum, device: @device)
    @images = 5.times.map { create(:image, log_datum: @log_datum) }

    @other_image = create(:image)
  end

  describe "GET /streams/log_data/:log_datum_id/images" do
    it "should return a list of images" do
      expect(@images).not_to be_empty

      get "/streams/log_data/#{@log_datum.id}/images",
          nil,
          {"X-Access-Token" => @device_access_token.token}
      expect(response).to have_http_status(:ok)

      expect(json_body.count).to eq @images.count

      includes_other_images = json_body.index { |obj| obj["id"] == @other_image.id }
      expect(includes_other_images).to be_falsy
    end

    it "should not return images for unauthorized log data" do
      other_device = create(:device)
      @log_datum.device = other_device
      @log_datum.save!

      get "/streams/log_data/#{@log_datum.id}/images",
          nil,
          {"X-Access-Token" => @device_access_token.token}
      expect(response).to have_http_status(:not_found)
    end
  end
end
