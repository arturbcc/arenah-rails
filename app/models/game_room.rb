class GameRoom < ActiveRecord::Base
  extend FriendlyId

  has_many :topics
  has_many :characters

  friendly_id :name, :use => :slugged
  validates_presence_of :name, :slug
end
