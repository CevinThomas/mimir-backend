class RemoveChoicesJsonFromCards < ActiveRecord::Migration[7.0]
  def change
    remove_column :cards, :choices, :jsonb
  end
end
