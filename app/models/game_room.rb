class GameRoom < ActiveRecord::Base
  extend FriendlyId

  has_many :topics
  has_many :characters
  has_many :game_room_subscriptions

  # TODO: when a game room is closed, the subscriptions must be removed.
  # A game Room is never deleted.

  # TODO: should we rename it to just 'game'?

  friendly_id :name, :use => :slugged
  validates_presence_of :name, :slug
end
