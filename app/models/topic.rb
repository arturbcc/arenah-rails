# frozen_string_literal: true

class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => :slugged

  # TODO: on delete, we must recount the post count of all characters
  # It should belongs to game room, or we need to remove the has_many topics from the game room
  has_many :posts, dependent: :delete_all
  belongs_to :topic_group
  belongs_to :game

  validates :title, length: { maximum: 100 }
  validates :game_id, :slug, presence: true

  scope :by_group_id, ->(group_id) { joins(:topic_group)
    .where('topic_groups.id = ?', group_id).order('topic_groups.position')
  }

  # TODO: check if this method is necessary. If so, maybe it should be in a
  # after save of the post instance
  # def recalculate_last_post
  #   last_post = posts.last
  #   post_id = last_post.id
  #   save!
  # end
end
