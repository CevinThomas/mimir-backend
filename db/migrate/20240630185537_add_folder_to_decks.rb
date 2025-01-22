class AddFolderToDecks < ActiveRecord::Migration[7.0]
  def change
    add_reference :decks, :folder, null: true, foreign_key: true, type: :uuid
  end
end
