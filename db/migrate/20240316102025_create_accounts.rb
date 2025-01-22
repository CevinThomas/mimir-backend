class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts, id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.string :name
      t.timestamps
    end
  end
end
