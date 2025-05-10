class CreateDecksFolder < ActiveRecord::Migration[7.0]
  def change
    create_table :decks_folder, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.references :deck, null: false, foreign_key: true, type: :uuid
      t.references :folder, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end