class CreatePostRecipients < ActiveRecord::Migration[5.0]
  def change
    create_table :post_recipients do |t|
      t.integer :post_id
      t.integer :character_id

      t.timestamps null: false
    end
  end
end
