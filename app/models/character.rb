# frozen_string_literal: true

class Character < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  enum status: { inactive: 0, active: 1 }
  enum character_type: { pc: 0, npc: 1, game_master: 2 }
  enum gender:  { male: 0, female: 1 }
  enum sheet_mode: { freemode: 0, gamemode: 1 }

  belongs_to :user
  belongs_to :game
  has_many :posts

  has_many :sent_messages, -> { order(created_at: :desc) }, foreign_key: :from, class_name: 'Message'
  has_many :received_messages, -> { order(created_at: :desc) }, foreign_key: :to, class_name: 'Message'

  validates :name, :user_id, :slug, :character_type, :status, :gender, :sheet_mode, presence: true
  validates :name, length: { maximum: 100 }

  def sheet
    @sheet ||= begin
      sheet = Sheet::Sheet.new(super)
      apply_attributes_relationship_on(sheet)
    end
  end

  # TODO: Is this method necessary?
  # def sheet_attributes=(hash)
  #   sheet.assign_attributes(hash)
  #   self[:sheet] = sheet.as_json
  # end

  def life_attribute
    return nil unless game.system.life.present?

    game.system.life.tap do |life|
      group_name = life.life.base_attribute_group
      attribute_name = life.base_attribute_name
    end

    sheet.find_character_attribute(group_name, life_attribute_name)
  end

  def active_pc?
    active? && pc? && belongs_to_active_game?
  end

  def active_game_master?
    active? && game_master? && belongs_to_active_game?
  end

  private

  def belongs_to_active_game?
    game.present? && game.active?
  end

  def apply_attributes_relationship_on(sheet)
    sheet.apply_attributes_relationship!

    if game && game.system
      sheet.apply_table_data!(game.system)

      sheet.life = sheet.find_character_attribute(
        game.system.life.base_attribute_group,
        game.system.life.base_attribute_name) if game.system.life.present?
    end

    sheet
  end
end
