class AddReadOnlyToAccessTokens < ActiveRecord::Migration
  def change
    add_column :access_tokens, :read_only, :boolean, default: false
  end
end
