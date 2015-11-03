class CreateGameRooms < ActiveRecord::Migration
  def change
    create_table :game_rooms do |t|
      t.integer :character_id, index: true, foreign_key: true
      t.string :name, null: false
      t.string :subtitle
      t.string :short_description
      t.string :description
      t.string :banner_url
      t.string :css
      t.string :slug, null: false
      t.integer :status, default: 1
      t.string :google_analytics_code
      t.boolean :show_signature, default: true

      t.timestamps null: false
    end

    add_index :game_rooms, :slug, :unique => true
  end
end
