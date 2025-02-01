class CreateDeckShareSession < ActiveRecord::Migration[7.0]
  def change
    create_table :deck_share_sessions, id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.references :deck, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :owner_user, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
