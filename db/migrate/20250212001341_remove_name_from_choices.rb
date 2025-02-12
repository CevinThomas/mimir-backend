class RemoveNameFromChoices < ActiveRecord::Migration[7.0]
  def change
    remove_column :choices, :name, :string
  end
end
