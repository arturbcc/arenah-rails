# frozen_string_literal: true

class TopicGroup < ActiveRecord::Base
  TOPIC_GROUP_LIMIT = 4

  extend FriendlyId
  friendly_id :name, :use => :slugged

  #TODO: When we have a delete cascade, we must recount the character's posts.
  has_many :topics, dependent: :delete_all
  belongs_to :game

  validates :name, length: { maximum: 100 }
  validates :game_id, :name, :slug, presence: true
end
