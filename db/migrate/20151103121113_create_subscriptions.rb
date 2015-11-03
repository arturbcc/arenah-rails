class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id, null: false, index: true, foreign_key: true
      t.integer :game_id, null: false, index: true, foreign_key: true
      t.integer :status, default: 0, null: false

      t.timestamps null: false
    end
  end
end
