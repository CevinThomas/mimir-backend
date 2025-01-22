class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results do |t|
      t.integer :correct_answers
      t.integer :total_cards
      t.jsonb :cards
      t.string :timespan
      t.timestamps
    end
  end
end
