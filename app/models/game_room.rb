# TODO: should we rename it to just 'game'?
class GameRoom < ActiveRecord::Base
  extend FriendlyId

  has_many :topics
  has_many :characters
  has_many :subscriptions

  friendly_id :name, :use => :slugged
  validates_presence_of :name, :slug

  def close!
    inactive!
    subscriptions.each(&:destroy)
  end

  def reopen!
    active!
  end

  private

  enum status: [:inactive, :active]
end
