class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => :slugged

  has_many :posts
  belongs_to :topic_group

  validates :title, length: { maximum: 100 }
  validates_presence_of :game_room_id, :slug
end
