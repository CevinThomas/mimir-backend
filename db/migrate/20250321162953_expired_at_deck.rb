class ExpiredAtDeck < ActiveRecord::Migration[7.0]
  def change
    add_column :decks, :expired_at, :datetime, null: true
  end
end
