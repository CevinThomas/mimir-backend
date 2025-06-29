class CreateOmniauthRequestTable < ActiveRecord::Migration[7.0]
  def change
    create_table :omniauth_request do |t|
      t.string :provider, null: false
      t.string :email, null: false
      t.string :expired, default: false

      t.timestamps
    end
  end
end
