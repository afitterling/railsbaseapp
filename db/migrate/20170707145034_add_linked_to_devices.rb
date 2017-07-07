class AddLinkedToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :linked, :boolean, null: false, default: false
  end
end
