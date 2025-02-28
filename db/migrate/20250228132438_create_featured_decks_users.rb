class CreateFeaturedDecksUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :featured_decks_users do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :deck, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
