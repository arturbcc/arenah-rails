class TopicGroup < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  #TODO: When we have a delete cascade, we must recount the character's posts.
  has_many :topics, dependent: :delete_all
  belongs_to :game

  validates :name, length: { maximum: 100 } # check the correct limit
  validates_presence_of :game_id, :name, :slug
end
