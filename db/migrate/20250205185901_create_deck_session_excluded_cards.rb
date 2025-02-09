class CreateDeckSessionExcludedCards < ActiveRecord::Migration[7.0]
  def change
    create_table :deck_session_excluded_cards do |t|
      t.references :deck_session, null: false, foreign_key: true, type: :uuid
      t.references :card, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
