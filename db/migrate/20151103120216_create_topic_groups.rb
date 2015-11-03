class CreateTopicGroups < ActiveRecord::Migration
  def change
    create_table :topic_groups do |t|
      t.integer :game_room_id, index: true, foreign_key: true, null: false
      t.string :name, limit: 100, null: false
      t.integer :position, default: 0
      t.string :slug, null: false

      t.timestamps null: false
    end

    add_index :topic_groups, :slug, :unique => true
  end
end
