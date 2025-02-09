class CreatePromoteRequestsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :promote_requests, id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :deck, null: false, foreign_key: true, type: :uuid
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end
  end
end
