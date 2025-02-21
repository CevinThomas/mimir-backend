class AddLastCardToDeckSession < ActiveRecord::Migration[7.0]
  def change
    add_column :deck_sessions, :last_card_id, :uuid
  end
end
