class CleanDeckSessionCardsTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :deck_session_cards, :answered, :boolean
    remove_column :deck_session_cards, :correct, :boolean
    remove_column :deck_session_cards, :answered_choice, :integer
    remove_column :deck_session_cards, :choices, :jsonb
  end
end
