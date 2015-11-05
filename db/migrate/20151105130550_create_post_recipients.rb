class CreatePostRecipients < ActiveRecord::Migration
  def change
    create_table :post_recipients do |t|
      t.integer :post_id
      t.integer :character_id

      t.timestamps null: false
    end
  end
end
