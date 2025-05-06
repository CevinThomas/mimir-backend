class AnsweredCard < ActiveRecord::Migration[7.0]
  def change
    create_table :answered_cards do |t|
      t.references :card, null: false, foreign_key: true, type: :uuid
      t.references :deck_session, null: false, foreign_key: true, type: :uuid
      t.references :choice, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.boolean :correct, null: false, default: false
      t.datetime :answered_at, null: false

      t.timestamps
    end
  end
end
