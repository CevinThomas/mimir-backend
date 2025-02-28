class AddAccountToDecksFolder < ActiveRecord::Migration[7.0]
  def change
    add_reference :decks_folders, :account, null: false, foreign_key: true, type: :uuid
  end
end
