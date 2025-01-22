class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string :name
      t.string :email
      t.timestamps
      t.references :department, null: true, foreign_key: true
      t.references :account, null: true, foreign_key: true, type: :uuid
    end
  end
end
