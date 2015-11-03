class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :nickname, :use => :slugged

  # TODO: If I delete the characters, the posts and topics must allow character_id null.
  # Check what is the correct behaviour
  has_many :characters, dependent: :delete_all
  has_many :game_room_subscriptions, dependent: :delete_all

  validates :name, :nickname, length: { maximum: 100 } #Check the correct limit
  validates_presence_of :email, :password, :name, :nickname, :slug
end