# frozen_string_literal: true

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

  def system
    @system ||= Sheet::System.new(super)
  end

  # TODO: Do we need this method?
  # def system_attributes=(hash)
  #   system.assign_attributes(hash)
  #   self[:system] = system.as_json
  # end

  def close!
    inactive!
    subscriptions.each(&:destroy)
  end

  def reopen!
    active!
  end

  def pcs
    find_by_type(0)
  end

  def npcs
    find_by_type(1)
  end

  def masters
    find_by_type(2)
  end

  private

  def find_by_type(type)
    characters
      .where('characters.character_type = ?', type)
      .order('characters.name')
  end
end
