class Character < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  #belongs_to :user
  #belongs_to :game_room
  has_many :posts

  validates_presence_of :name, :user_id, :game_room_id, :slug
end