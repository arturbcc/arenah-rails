class RemovePostIdFromTopics < ActiveRecord::Migration[5.0]
  def change
    remove_column :topics, :post_id
  end
end
