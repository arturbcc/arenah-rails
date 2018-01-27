class RenameSheetOnCharacter < ActiveRecord::Migration[5.1]
  def change
    rename_column :characters, :sheet, :raw_sheet
  end
end
