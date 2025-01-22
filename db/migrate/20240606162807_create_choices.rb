class CreateChoices < ActiveRecord::Migration[7.0]
  def change
    create_table :choices, force: :cascade do |t|
      t.string :name, null: false
      t.boolean :correct, null: false
      t.references :card, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
