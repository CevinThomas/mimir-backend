class UpdateAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :email, :string, null: false
    add_column :accounts, :allow_whitelist, :boolean, default: false
  end
end
