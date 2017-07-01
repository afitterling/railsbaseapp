require 'rails_helper'

RSpec.describe "LogDataImageUpload", type: :request do
  before(:each) do
    @device = create(:device)
    @device_access_token = create(:device_access_token, device: @device)
    @log_datum = create(:log_datum, device: @device)
    @image = fixture_file_upload(Rails.root.join('spec', 'image.png'), 'image/png')
  end

  describe "POST /streams/log_data/:log_datum_id/images" do
    it "should create image objects with valid params" do
      expect do
        post "/streams/log_data/#{@log_datum.id}/images",
             {images: [@image, @image]},
             {"X-Access-Token" => @device_access_token.token}
        expect(response).to have_http_status(:ok)
      end.to change { @log_datum.images.count }.by(2)
    end

    it "should not create image for unauthorized log data" do
      other_device = create(:device)
      @log_datum.device = other_device
      @log_datum.save!

      expect do
        post "/streams/log_data/#{@log_datum.id}/images",
             {images: [@image]},
             {"X-Access-Token" => @device_access_token.token}
        expect(response).to have_http_status(:not_found)
      end.not_to change { @log_datum.images.count }
    end
  end
end
