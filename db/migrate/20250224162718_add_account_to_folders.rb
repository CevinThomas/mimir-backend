class AddAccountToFolders < ActiveRecord::Migration[7.0]
  def change
    add_reference :folders, :account, type: :uuid, null: false, foreign_key: true
  end
end
