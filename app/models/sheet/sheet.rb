# frozen_string_literal: true

module Sheet
  class Sheet
    include EmbeddedModel

    attr_accessor :pages, :attributes_groups

    # Attributes that are not stored in the database
    attr_accessor :calculator, :life, :initiative

    # Public: List all attributes' groups filtered by a set of conditions
    # sorted by the `order` attribute.
    #
    #  system.sheet.attributes_groups_by(page: 1, position: 'column_1')
    #  => [{ name: 'Atributos', order: 1, page: 1, position: 'column_1', ... },
    #      { name: 'Aprimoramentos', order: 2, page: 1, position: 'column_1', ... }]
    #
    # Returns an ordered list of attributes groups
    def attributes_groups_by(attributes_hash = {})
      return [] unless attributes_groups.present?

      attributes_groups
        .select { |group| meet_conditions?(group, attributes_hash) }
        .sort_by { |group| group.order }
    end

    def find_attributes_group(name)
      return nil unless attributes_groups.present?

      attributes_groups.detect { |group| group.name == name }
    end

    def find_character_attribute(group_name, attribute_name)
      group = find_attributes_group(group_name)
      return nil unless group

      group.character_attributes.detect {|attr| attr.name == attribute_name }
    end

    # Public: link all attributes' groups and build the
    # character sheet relationships, parsing the formulas to calculate points
    # and binding attributes that are based in others.
    #
    # Returns: the sheet
    def apply_attributes_relationship!
      return unless attributes_groups

      self.calculator = ::Sheet::Calculator.new
      save_attributes_as_variables

      calculate_equipment_modifiers
      calculate_group_points
      calculate_based_attributes

      # TODO: I need to remember to never modify the points of any attribute. Save
      # in separated fields and use the method `value` to sum them up

      # TODO: I must never let an attribute be based on another based attribute
      # Can it be based on a type=table group? To do that I need to parse the table
      # groups before everything, but the points will not be ready yet
      self
    end

    # Public: Fill the points of all attributes that are based in a table. The
    # table belongs to the game system, not the sheet itself, and has a base
    # attribute to be used as a key.
    #
    # Returns: the sheet
    def apply_table_data!(game_system)
      attributes_groups_by(type: 'table').each do |group|
        next unless group.character_attributes

        group.character_attributes.each do |attribute|
          base_attribute = find_character_attribute(
            attribute.base_attribute_group,
            attribute.base_attribute_name
          )

          table = game_system.find_table(attribute.table_name)

          if table.present?
            attribute.points = table.value(base_attribute.value.to_s)
            attribute.unit = table.unit
          end
        end
      end

      self
    end

    private

    def nested_attributes
      %w(pages attributes_groups)
    end

    def meet_conditions?(group, attributes_hash)
      attributes_hash.reduce(true) do |value, object|
        value &&= group.public_send("#{object[0]}") == object[1]
      end
    end

    def save_attributes_as_variables
      attributes_groups.each do |group|
        next unless group.character_attributes

        group.character_attributes.each do |attribute|
          self.calculator.add_variable(group.name, attribute.name, attribute.value)
        end
      end
    end

    # Private: iterates through the attributes' groups collecting those
    # with a formula to be parsed.
    #
    # The points will be set on the character sheet attributes group, and they
    # will be different for each character in the game.
    def calculate_group_points
      attributes_groups.each do |group|
        if group.group_points_formula.present?
          character_group = self.find_attributes_group(group.name)
          character_group.points = self.calculator.evaluate(group.group_points_formula)
        end
      end
    end

    # Private: Looks for attributes based in other attributes and saves a
    # reference to their base attributes.
    def calculate_based_attributes
      attributes_groups_by(type: 'based').each do |group|
        next unless group.character_attributes

        # TODO: remember to check if the attribute that is going to serve as
        # the base does not have a base too, or it can go down to a deadlock
        # this security check can be made on the controller, when the attributes
        # are saved
        group.character_attributes.each do |attribute|
          attribute.base_attribute = find_character_attribute(
            attribute.base_attribute_group,
            attribute.base_attribute_name
          )
        end
      end
    end

    # Private: iterates through the list of equipments and, if the equipment is
    # equipped, set the modifiers to the attributes it is supposed to change
    def calculate_equipment_modifiers
      attributes_groups_by(type: 'equipments').each do |group|
        next unless group.equipments

        group.equipments.each do |equipment|
          if equipment.equipped_on.present?
            equipment.modifiers.each do |modifier|
              attribute = find_character_attribute(
                modifier.base_attribute_group,
                modifier.base_attribute_name
              )

              attribute.equipment_modifier = 0 if attribute.equipment_modifier.blank?
              attribute.equipment_modifier += modifier.value if attribute
            end
          end
        end
      end
    end
  end
end
