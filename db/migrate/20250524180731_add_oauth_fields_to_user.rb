class AddOauthFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :oauth_provider, :string
    add_column :users, :oauth_uid, :string
  end
end
