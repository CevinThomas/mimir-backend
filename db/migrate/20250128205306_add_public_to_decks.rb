class AddPublicToDecks < ActiveRecord::Migration[7.0]
  def change
    add_column :decks, :public, :boolean, default: false
  end
end
