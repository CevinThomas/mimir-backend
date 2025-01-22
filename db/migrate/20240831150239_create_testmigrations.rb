class CreateTestmigrations < ActiveRecord::Migration[7.0]
  def change
    create_table :testmigrations do |t|
      t.string :name

      t.timestamps
    end
  end
end
