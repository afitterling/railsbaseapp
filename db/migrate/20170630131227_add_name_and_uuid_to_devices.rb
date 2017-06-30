class AddNameAndUuidToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :name, :string
    add_column :devices, :uuid, :string
    add_index :devices, :uuid, unique: true
  end
end
