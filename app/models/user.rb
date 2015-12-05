class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :nickname, :use => :slugged

  has_many :characters, dependent: :delete_all
  has_many :subscriptions, dependent: :delete_all

  validates :name, :nickname, length: { maximum: 100 } #Check the correct limit
  validates :email, :password, :name, :nickname, :slug, presence: true
end
