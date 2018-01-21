class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :character_id, index: true, foreign_key: true, null: false
      t.string :name, null: false, limit: 45
      t.string :subtitle
      t.text :short_description, limit: 330
      t.text :description
      t.string :banner
      t.string :css
      t.string :slug, null: false
      t.integer :status, default: 1
      t.string :google_analytics_code
      t.boolean :show_signature, default: true
      t.jsonb :system, default: {}, null: false

      t.timestamps null: false
    end

    add_index :games, :slug, :unique => true
    add_index  :games, :system, using: :gin
  end
end
