class SwitchExplanation < ActiveRecord::Migration[7.0]
  def change
    remove_column :choices, :explanation, :string
    add_column :cards, :explanation, :string
  end
end
