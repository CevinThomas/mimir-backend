class AddCompletedToDeckSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :deck_sessions, :completed, :boolean, default: false
  end
end