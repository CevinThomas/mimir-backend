class MakePasswordDigestOptional < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :password_digest, :string, null: true
  end
end
