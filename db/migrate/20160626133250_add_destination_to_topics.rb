class AddDestinationToTopics < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :destination, :integer, default: 1, null: false
  end
end
