class AddTypeToDecks < ActiveRecord::Migration[7.0]
  def change
    add_column :decks, :deck_type, :string, default: 'private'
  end
end
