class MakeActiveFalseDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :decks, :active, false
  end
end
