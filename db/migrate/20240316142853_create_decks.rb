class CreateDecks < ActiveRecord::Migration[7.0]
  def change
    create_table :decks, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string :name
      t.string :description
      t.timestamps
      t.references :user, null: true, foreign_key: true, type: :uuid
      t.references :account, null: true, foreign_key: true, type: :uuid
    end
  end
end
