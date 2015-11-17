class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :character_id, index: true, foreign_key: true
      t.string :name, null: false
      t.string :subtitle
      t.string :short_description
      t.string :description
      t.string :banner
      t.string :css
      t.string :slug, null: false
      t.integer :status, default: 1
      t.string :google_analytics_code
      t.boolean :show_signature, default: true

      t.timestamps null: false
    end

    add_index :games, :slug, :unique => true
  end
end
