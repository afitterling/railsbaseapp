class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.string :url, null: false
      t.boolean :active, default: true, null: false
      t.references :device, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
