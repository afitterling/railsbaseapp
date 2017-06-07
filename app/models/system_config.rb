class SystemConfig < ActiveRecord::Base
  DEFAULT_VALUES = {
    "key_rotation" => "true"
  }

  def self.respond_to?(method, include_all = false)
    property = method.to_s.chomp('=')
    return true if DEFAULT_VALUES.has_key?(property)
    super
  end

  def self.method_missing(method, *args, &block)
    method_str = method.to_s
    property = method_str.chomp('=')

    return super(method, *args, &block) unless DEFAULT_VALUES.has_key?(property)

    if /\=\z/ =~ method_str
      config = self.find_or_create_by(key: property)
      config.value = args.first
      config.save
    else
      self.find_by(key: property)&.value || DEFAULT_VALUES[property]
    end
  end
end
