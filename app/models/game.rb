class Game < ActiveRecord::Base
  extend FriendlyId

  has_many :topics
  has_many :topic_groups
  has_many :characters
  has_many :subscriptions

  belongs_to :character

  friendly_id :name, :use => :slugged

  validates :name, length: { maximum: 45 }
  validates :short_description, length: { maximum: 320 }
  validates :name, :slug, presence: true

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

  def masters
    characters
      .where('characters.character_type = ?', 2)
      .order('characters.name')
  end
end
