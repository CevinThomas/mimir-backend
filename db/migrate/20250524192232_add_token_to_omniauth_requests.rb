class AddTokenToOmniauthRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :omniauth_request, :token, :string, null: false, default: -> { "gen_random_uuid()" }
  end
end
