class CreateDeviceAccessTokens < ActiveRecord::Migration
  def change
    create_table :device_access_tokens do |t|
      t.string :token
      t.integer :sequence
      t.references :device, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :device_access_tokens, :token, unique: true
  end
end
