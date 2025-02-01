class AddShareUuidStringToDecks < ActiveRecord::Migration[7.0]
  def change
    add_column :decks, :share_uuid, :uuid, null: true
  end
end
