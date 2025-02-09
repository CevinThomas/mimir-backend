class UpdateDeckSessionTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :deck_sessions, :choices, :jsonb
    remove_column :deck_sessions, :selected_choices, :jsonb
    remove_column :deck_sessions, :current_card_index, :integer
    remove_column :deck_sessions, :total_cards, :integer
    remove_column :deck_sessions, :completed_at, :datetime
    remove_column :deck_sessions, :started_at, :datetime
  end
end
