class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :last_used_key_sequence, null: false, default: -1

      t.timestamps null: false
    end
  end
end
