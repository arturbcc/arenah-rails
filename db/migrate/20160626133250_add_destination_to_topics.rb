class AddDestinationToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :destination, :integer, default: 1, null: false
  end
end
