# frozen_string_literal: true

# Public: Represents a group of topics
#
# The default_topics_destination attribute decides where to redirect the user
# when he/she enters in a topic. The possible values are:
#
# * 0: redirects to first page
# * 1: redirects to last page and last post
class TopicGroup < ApplicationRecord
  TOPIC_GROUP_LIMIT = 3

  extend FriendlyId
  friendly_id :name, :use => :slugged

  #TODO: When we have a delete cascade, we must recount the character's posts.
  has_many :topics, dependent: :delete_all
  belongs_to :game

  validates :name, length: { maximum: 20 }
  validates :game_id, :name, :slug, presence: true
end
