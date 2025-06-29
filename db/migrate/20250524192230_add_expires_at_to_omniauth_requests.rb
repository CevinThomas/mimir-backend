class AddExpiresAtToOmniauthRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :omniauth_request, :expires_at, :datetime, default: -> { "CURRENT_TIMESTAMP" }
    remove_column :omniauth_request, :expired
  end
end