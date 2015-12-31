class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :from, foreign_key: true, null: false
      t.integer :to, foreign_key: true, null: false
      t.string :body
      t.boolean :read, default: false

      t.timestamps null: false
    end

    add_index :messages, :from
  end
end
