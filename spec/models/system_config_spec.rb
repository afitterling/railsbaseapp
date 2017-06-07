require 'rails_helper'

RSpec.describe SystemConfig, type: :model do
  describe "class" do
    it "should have a DEFAULT_VALUES hash" do
      expect(SystemConfig.const_defined?(:DEFAULT_VALUES)).to eq true
    end

    it "should have accessors for the config options" do
      SystemConfig::DEFAULT_VALUES.keys.each do |key|
        expect(SystemConfig).to respond_to key
        expect(SystemConfig).to respond_to "#{key}="
      end
    end

    it "should return default value for the options" do
      SystemConfig::DEFAULT_VALUES.each do |key, value|
        expect(SystemConfig.send(key)).to eq value
      end
    end

    it "should update the config value using writer methods" do
      SystemConfig::DEFAULT_VALUES.each do |key, value|
        new_value = "hello-#{value}"

        expect(SystemConfig.send(key)).not_to eq new_value

        SystemConfig.send("#{key}=", new_value)
        expect(SystemConfig.send(key)).to eq new_value

        obj = SystemConfig.find_by(key: key)
        expect(obj).not_to be_nil
        expect(obj.value).to eq new_value
      end
    end

    it "should be able to read and set value using subscript notation" do
      SystemConfig::DEFAULT_VALUES.each do |key, value|
        expect(SystemConfig[key]).to eq value
        new_value = "hello-#{value}"
        SystemConfig[key] = new_value
        expect(SystemConfig[key]).to eq new_value
        obj = SystemConfig.find_by(key: key)
        expect(obj).not_to be_nil
        expect(obj.value).to eq new_value
      end
    end
  end
end
