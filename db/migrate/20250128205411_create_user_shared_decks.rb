class CreateUserSharedDecks < ActiveRecord::Migration[7.0]
  def change
    create_table :user_shared_decks do |t|
      t.uuid :deck_id, null: false
      t.uuid :user_id, null: false
      t.timestamps

      add_foreign_key :user_shared_decks, :decks, column: :deck_id
      add_foreign_key :user_shared_decks, :users, column: :user_id
    end
  end
end
