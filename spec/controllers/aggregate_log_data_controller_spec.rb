require 'rails_helper'

RSpec.describe AggregateLogDataController, type: :controller do
  describe 'index' do
    before(:each) do
      @access_token = create(:access_token, read_only: true)
      @user = @access_token.user
      @devices = 10.times.map { create(:device, user: @user) }
      @log_data = @devices.map { |device| create(:log_datum, device: device, payload: {hello: "device_#{device.id}"}) }
    end

    it 'should return log data from the list of devices' do
      request.headers.merge!("X-Access-Token" => @access_token.token)
      get :index, device_ids: @devices.first(2).map(&:id).inspect
      expect(response).to have_http_status(:ok)
      expect(json_body.count).to eq 2
      expect(json_body).to have_key(@devices[0].id.to_s)
      expect(json_body).to have_key(@devices[1].id.to_s)

      (0..1).each do |i|
        device_data_ids = @devices[i].log_data.map(&:id).sort
        response_device_data_ids = json_body[@devices[i].id.to_s].map { |data| data["id"] }.sort
        expect(device_data_ids).to eq response_device_data_ids
      end
    end

    it 'should default the list of devices to the empty list' do
      request.headers.merge!("X-Access-Token" => @access_token.token)
      get :index
      expect(response).to have_http_status(:ok)
      expect(json_body.count).to eq 0
    end

    it 'should not expose data from another user\'s devices' do
      other_user = create(:user)
      device = @devices.first
      device.user = other_user
      device.save!

      request.headers.merge!("X-Access-Token" => @access_token.token)
      get :index, device_ids: "[#{device.id}]"
      expect(response).to have_http_status(:ok)
      expect(json_body.count).to eq 0
    end

    it 'should fail without a token' do
      get :index
      expect(response).to have_http_status(:unauthorized)
      expect(json_body).to have_key("errors")
    end

    it 'should fail with an invalid token' do
      token = 'hello_world'
      expect(AccessToken.find_by(token: token)).to be_nil
      request.headers.merge!("X-Access-Token" => token)
      get :index
      expect(response).to have_http_status(:unauthorized)
      expect(json_body).to have_key("errors")
    end

    it 'should fail with a device token' do
      device = @devices.last
      device.key_rotation_enabled = false
      device.save!
      device_access_token = create(:device_access_token, device: device)

      request.headers.merge!("X-Access-Token" => device_access_token.token)
      get :index, device_ids: "[#{device.id}]"
      expect(response).to have_http_status(:unauthorized)
      expect(json_body).to have_key("errors")
    end
  end
end
