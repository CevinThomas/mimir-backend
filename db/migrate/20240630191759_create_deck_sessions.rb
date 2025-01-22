class CreateDeckSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :deck_sessions, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.references :deck, null: true, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.jsonb :choices, null: false, default: []
      t.jsonb :selected_choices, null: true, default: []
      t.datetime :completed_at
      t.datetime :started_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.integer :current_card_index, null: false, default: 0
      t.integer :total_cards, null: false, default: 0
      t.timestamps
    end
  end
end
