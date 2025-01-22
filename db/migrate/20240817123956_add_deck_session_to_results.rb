class AddDeckSessionToResults < ActiveRecord::Migration[7.0]
  def change
    add_reference :results, :deck_session, null: false, foreign_key: true, type: :uuid
  end
end
