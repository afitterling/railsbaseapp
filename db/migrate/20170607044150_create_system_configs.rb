class CreateSystemConfigs < ActiveRecord::Migration
  def change
    create_table :system_configs do |t|
      t.string :key
      t.string :value

      t.timestamps null: false
    end
    add_index :system_configs, :key, unique: true
  end
end
