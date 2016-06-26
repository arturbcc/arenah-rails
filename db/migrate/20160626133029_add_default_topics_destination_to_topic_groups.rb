class AddDefaultTopicsDestinationToTopicGroups < ActiveRecord::Migration
  def change
    add_column :topic_groups, :default_topics_destination, :integer, default: 1, null: false
  end
end
