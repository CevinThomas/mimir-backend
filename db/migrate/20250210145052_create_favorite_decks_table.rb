class CreateFavoriteDecksTable < ActiveRecord::Migration[7.0]
  def change
    create_table :favorite_decks do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :deck, null: false, foreign_key: true, type: :uuid
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
