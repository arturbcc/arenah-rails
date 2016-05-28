class RemovePostIdFromTopics < ActiveRecord::Migration
  def change
    remove_column :topics, :post_id
  end
end
