class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :topic_id, index: true, foreign_key: true
      t.integer :character_id, index: true, foreign_key: true
      t.string :message, null: false

      t.timestamps null: false
    end
  end
end
