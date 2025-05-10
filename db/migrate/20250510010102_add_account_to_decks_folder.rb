class AddAccountToDecksFolder < ActiveRecord::Migration[7.0]
  def change
    add_reference :decks_folder, :account, type: :uuid, null: false, foreign_key: true
  end
end