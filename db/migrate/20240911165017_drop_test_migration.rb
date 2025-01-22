class DropTestMigration < ActiveRecord::Migration[7.0]
  def change
    drop_table :testmigrations
  end
end
