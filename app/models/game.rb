class Game < ActiveRecord::Base
  extend FriendlyId

  has_many :topics
  has_many :topic_groups
  has_many :characters
  has_many :subscriptions

  belongs_to :character

  friendly_id :name, :use => :slugged
  validates_presence_of :name, :slug

  enum status: [:inactive, :active]

  def close!
    inactive!
    subscriptions.each(&:destroy)
  end

  def reopen!
    active!
  end

  def pcs
    characters
      .where('characters.character_type = ?', 0)
      .order('characters.name')
  end
end