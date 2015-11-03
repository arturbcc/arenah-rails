class TopicGroup < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  has_many :topics, dependent: :delete_all
  #When we have a delete cascade, we must recount the character's posts.

  validates :name, length: { maximum: 100 }
  validates_presence_of :game_room_id, :name, :slug
end
