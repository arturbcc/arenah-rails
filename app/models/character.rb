# frozen_string_literal: true

class Character < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  enum status: { inactive: 0, active: 1 }
  enum character_type: { pc: 0, npc: 1, game_master: 2 }
  enum gender:  { male: 0, female: 1 }

  # Public: the sheet mode tells how the character sheet can be modified.
  #
  # * free_mode: all modifications are allowed. It is very useful before the
  #   character starts to play the game, where modifications will be made
  #   frequently and have to be analyzed by the game master until the sheet
  #   follows all the rules of the game. In this mode, the users can add more
  #   attributes than they should (their attribute's group's points will be
  #   negative) or the sheet can still be incomplete.
  #
  # * game_mode: it means the sheet is ready and the character can play the
  #   game. He/she will not be able to descrease points in the attributes, nor
  #   will be able to add attributes to groups or remove them from there.
  #
  #   In this mode, changes are only allowed if there are still remaining points
  #   in a group, which is useful if the user gains points when they level up. A
  #   pro tip here is to incentivate game masters to create attributes groups
  #   with the total points based on the character level, so by simply
  #   leveling up characters will give them points to change the sheet, the
  #   scenario for which this mode was created. The user can change, but only
  #   on level up scenarios.
  #
  #   Be aware that if the user does not use all points before entering in the
  #   game mode he/she will be able to change the sheet during the game. If it
  #   is not a desired scenario, the game master have to either prevent a user
  #   to start without using all points or change the sheet to the
  #   game_master_mode.
  #
  # * game_master_mode: no changes are allowed unless the logged user is the
  #   game master. Not even the user that created the character will be able to
  #   tamper with the sheet. It is used when the game master want to have full
  #   controll of the changes.
  enum sheet_mode: { free_mode: 0, game_mode: 1,  }

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
