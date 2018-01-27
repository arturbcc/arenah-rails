class RenameSystemOnGame < ActiveRecord::Migration[5.1]
  def change
    rename_column :games, :system, :raw_system
  end
end
