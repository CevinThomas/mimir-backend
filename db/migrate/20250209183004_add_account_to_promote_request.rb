class AddAccountToPromoteRequest < ActiveRecord::Migration[7.0]
  def change
    add_reference :promote_requests, :account, null: false, foreign_key: true, type: :uuid
  end
end
