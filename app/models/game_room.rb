class GameRoom < ActiveRecord::Base
  extend FriendlyId

  has_many :topics
  has_many :characters
  has_many :game_room_subscriptions

  friendly_id :name, :use => :slugged
  validates_presence_of :name, :slug
end
