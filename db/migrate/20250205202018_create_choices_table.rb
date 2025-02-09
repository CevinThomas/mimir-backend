class CreateChoicesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :choices, id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.string :name, null: false
      t.string :title, null: false
      t.string :description
      t.string :explanation
      t.boolean :correct, default: false
      t.timestamps
    end
  end
end
