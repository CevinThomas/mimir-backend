class AddLastCheckedDecksToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :last_checked_decks, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
