class CreateDeckSessionCards < ActiveRecord::Migration[7.0]
  def change
    create_table :deck_session_cards, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.references :deck_session, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.string :title, null: false
      t.string :description
      t.string :image
      t.boolean :answered, default: false
      t.boolean :correct
      t.integer :answered_choice

      t.jsonb :choices, default: [], null: false

      t.timestamps
    end
  end
end
