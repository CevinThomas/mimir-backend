class CreateFolderDecks < ActiveRecord::Migration[7.0]
  def change
    create_table :folder_decks do |t|
      t.references :folder, null: false, foreign_key: true, type: :uuid
      t.references :deck, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
