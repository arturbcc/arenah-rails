class TopicGroup < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  has_many :topics

  validates :name, length: { maximum: 100 }
  validates_presence_of :game_room_id, :name, :slug
end
