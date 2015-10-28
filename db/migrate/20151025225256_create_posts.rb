class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :topic_id
      t.integer :character_id
      t.string :message

      t.timestamps null: false
    end
  end
end
