class User < ActiveRecord::Base
  extend FriendlyId

  has_many :characters

  friendly_id :nickname, :use => :slugged

  validates :name, :nickname, length: { maximum: 100 }
  validates_presence_of :email, :password, :name, :nickname, :slug
end