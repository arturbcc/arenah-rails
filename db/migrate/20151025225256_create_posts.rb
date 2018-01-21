class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.integer :topic_id, null: false, index: true, foreign_key: true
      t.integer :character_id, index: true, foreign_key: true
      t.text :message, null: false, limit: 16777215

      t.timestamps null: false
    end
  end
end
