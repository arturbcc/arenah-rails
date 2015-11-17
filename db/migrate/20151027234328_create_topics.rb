class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :topic_group_id, index: true, foreign_key: true
      t.integer :game_id, index: true, foreign_key: true, null: false
      t.integer :character_id, index: true, foreign_key: true
      t.string :title, limit: 100, :null => false
      t.string :description
      t.integer :position, default: 0
      t.integer :post_id, index: true, foreign_key: true
      t.string :slug, :null => false

      t.timestamps null: false
    end

    add_index :topics, :slug, :unique => true
  end
end