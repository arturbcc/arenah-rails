class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :game_room_id #, index: true, foreign_key: true
      t.integer :user_id #, index: true, foreign_key: true
      t.string :title, limit: 100
      t.string :description
      t.integer :position
      t.integer :topic_group_id #, index: true, foreign_key: true
      t.integer :post_id, index: true, foreign_key: true
      t.string :slug, :null => false

      t.timestamps null: false
    end

    add_index :topics, :slug, :unique => true
  end
end