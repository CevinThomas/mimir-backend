class AddActiveToDecks < ActiveRecord::Migration[7.0]
  def change
    add_column :decks, :active, :boolean, default: true
  end
end
