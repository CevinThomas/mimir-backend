class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string :name, null: false
      t.string :title, null: false
      t.string :description
      t.string :image
      t.references :deck, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
