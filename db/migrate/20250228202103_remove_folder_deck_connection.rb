class RemoveFolderDeckConnection < ActiveRecord::Migration[7.0]
  def change
    remove_column :decks, :folder_id, :uuid
  end
end
