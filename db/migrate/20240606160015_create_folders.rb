class CreateFolders < ActiveRecord::Migration[7.0]
  def change
    create_table :folders, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string :name
      t.timestamps
      t.references :parent, type: :uuid, foreign_key: { to_table: :folders }
      t.references :user, type: :uuid, foreign_key: true
    end
  end
end
