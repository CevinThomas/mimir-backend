class RemovePublicFromDecks < ActiveRecord::Migration[7.0]
  def change
    remove_column :decks, :public, :boolean
  end
end
