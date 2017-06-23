class AddKeyRotationEnabledToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :key_rotation_enabled, :boolean
  end
end
