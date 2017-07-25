class AddTypeAndDescriptionToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :stream_type, :string
    add_column :devices, :description, :text
  end
end
