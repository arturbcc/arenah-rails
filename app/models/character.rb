# frozen_string_literal: true

class Character < ApplicationRecord
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
  enum sheet_mode: { free_mode: 0, game_mode: 1, game_master_mode: 2 }

  belongs_to :user
  belongs_to :game, optional: true
  has_many :posts

  has_many :sent_messages, -> { order(created_at: :desc) }, foreign_key: :from, class_name: 'Message'
  has_many :received_messages, -> { order(created_at: :desc) }, foreign_key: :to, class_name: 'Message'

  validates :name, :user_id, :slug, :character_type, :status, :gender, :sheet_mode, presence: true
  validates :name, length: { maximum: 100 }

  def sheet
    @sheet ||= begin
      character_sheet = Sheet::Sheet.new(raw_sheet)
      apply_attributes_relationship_on(character_sheet)
    end
  end

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

  # Public: Update the character sheet. Sheets are not updated all at once, but
  # in parts, group by group. This method also removes attributes that were
  # deleted by the user.
  #
  # This method receives only the attributes that will be changed and those
  # that will be removed in a specific group .
  #
  # - group_name: name of the group that will be updated.
  #
  # - changes: an array containing the list of attributes to change with the new
  #   values. Each item in the array contains three attributes:
  #
  #   * attribute_name: the name of the character's attribute that will be
  #     modified.
  #   * field_name: each attribute has a set of attributes on its own. For
  #     example, it can have `points` and `total`, or maybe a `content` if it
  #     is a text attribute. this `field_name` contains the name of the field
  #     that will receive the `value`.
  #   * value: the new value that will be saved in the `field_name` of the
  #     attribute with the given `attribute_name`.
  #
  #   Parameters example:
  #
  #   [
  #      {
  #        "attribute_name": "Strenght",
  #   		 "field_name": "points",
  #     	 "value": "10"
  #      },
  #      {
  #        "attribute_name": "Constitution",
  #     	 "field_name": "points",
  #     	 "value": "12"
  #      },
  #      ...
  #   ]
  #
  #  In the example above, the attribute `Strength` will have its `points`
  #  changed to 10, while the `Constitution` will have its `points` changed to
  #  12.
  #
  # - deleted_items: the user can remove attributes from a group, if the group
  #   is a list. In this case, this parameter will contain the names of all
  #   attributes that must be removed.
  #
  # - added_items: the user can add new attributes from a list, in case the
  #   group is a list. It is an array of hashes and each hash contain the name
  #   of the attribute to add and its points or cost. Cost has precedence over
  #   points, it will try to fetch the cost from the game system and, if no
  #   cost is available, it will then try to fetch the points.
  #
  #  Usage example:
  #
  #    character.update_sheet('Skills', [{ attribute_name: 'Strength',
  #      field_name: 'content', value: 'Jane Roe' }], ['Perception'])
  #    => true
  #
  # Returns the update status.
  def update_sheet(group_name:, changes: [], deleted_attributes: [], added_attributes:[])
    group = raw_sheet['attributes_groups'].find do |attributes_group|
      attributes_group['name'] == group_name
    end

    return false unless group

    # If the same attribute is in the `added_attributes` AND in the
    # `deleted_attributes`, no change will be done in the database, so we need
    # to remove it from both lists.
    added_attributes_names = added_attributes.map { |attribute| attribute['name'] }
    intersection = added_attributes_names & deleted_attributes
    intersection.each do |attribute_name|
      added_attributes.reject! { |attribute| attribute['name'] == attribute_name }
    end
    deleted_attributes -= intersection

    add_new_attributes(group, added_attributes)
    remove_deleted_attributes(group, deleted_attributes)

    modify_attributes(group, changes)

    save!
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

  def attribute_by_name(group, name)
    group['character_attributes'].find do |attribute|
      attribute['name'] == name
    end
  end

  def modify_attributes(group, changes)
    changes.each do |change|
      next unless ['content', 'points', 'total'].include?(change['field_name'])

      change['value'] = change['value'].to_i if change['field_name'] != 'content'
      attribute = attribute_by_name(group, change['attribute_name'])
      attribute[change['field_name']] = change['value'] if attribute.present?
    end
  end

  def add_new_attributes(group, added_attributes)
    added_attributes.each do |attribute|
      item = { name: attribute['name'] };
      if attribute['cost']
        item[:cost] = attribute['cost']
      elsif attribute['points']
        item[:points] = attribute['points']
      else
        next
      end

      sheet = self.game.system.sheet
      system_attribute = sheet.find_list_attribute(group['name'], attribute['name'])
      item[:base_attribute_group] = system_attribute.base_attribute_group if system_attribute&.base_attribute_group
      item[:base_attribute_name] = system_attribute.base_attribute_name if system_attribute&.base_attribute_name
      item[:description] = system_attribute.description if system_attribute&.description
      group['character_attributes'] << item.stringify_keys;
    end

    def remove_deleted_attributes(group, deleted_attributes)
      deleted_attributes.each do |attribute_name|
        group['character_attributes'].delete_if { |attribute| attribute['name'] == attribute_name }
      end
    end
  end
end
