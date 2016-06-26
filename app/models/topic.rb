# frozen_string_literal: true

# Public: Represents a topic
#
# The destination attribute decides where to redirect the user when he/she
# enters in the topic. The possible values are:
#
# * 0: redirects to first page
# * 1: redirects to last page and last post
# * 2: behaves according to the topic group rule
class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => :slugged

  # TODO: on delete, we must recount the post count of all characters
  # It should belongs to game room, or we need to remove the has_many topics from the game room
  has_many :posts, -> { order(:created_at) }, dependent: :delete_all
  belongs_to :topic_group
  belongs_to :game

  validates :title, length: { maximum: 100 }
  validates :game_id, :slug, presence: true

  scope :by_group_id, ->(group_id) { joins(:topic_group)
    .where('topic_groups.id = ?', group_id).order('topics.position')
  }

  def redirect_to_last_page?
    destination == 1 ||
    (destination == 2 && topic_group.default_topics_destination == 1)
  end

  def redirect_to_first_page?
    destination == 0 ||
    (destination == 2 && topic_group.default_topics_destination == 0)
  end
end
