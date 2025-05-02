class AddNoticeToDeck < ActiveRecord::Migration[7.0]
  def change
    add_column :decks, :notice, :text, default: nil, null: true
  end
end
