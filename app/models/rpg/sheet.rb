# frozen_string_literal: true

module RPG
  class Sheet
    include EmbeddedModel

    attr_accessor :pages, :attributes_groups

    attr_accessor :calculator

    # Public: lists all attributes groups on a given page, inside a given
    # position, sorted by the `order` attribute.
    #
    # Valid positions are: header, column_1, column_2, column_3 and footer
    #
    #  system.sheet.attributes_groups_by(page: 1, position: 'column_1')
    #  => [{ name: 'Atributos', order: 1, page: 1, position: 'column_1', ... },
    #      { name: 'Aprimoramentos', order: 2, page: 1, position: 'column_1', ... }]
    #
    # Returns an ordered list of attributes groups for a given position
    def attributes_groups_by(page:, position:)
      attributes_groups
        .select { |group| group.page == page && group.position == position }
        .sort_by { |group| group.order }
    end

    def find_attributes_group(name)
      attributes_groups.detect { |group| group.name == name }
    end

    # Public: this method will link all attributes' groups and build the
    # character sheet relationships, parsing the formulas to calculate points
    # and binding attributes that are based in others.
    #
    # Paramters:
    # * game_system: every system has its own sheet model. It contains all the
    #   rules and formulas, while the character sheet has just a skeleton
    #   of the game system with the attributes related to its owner.
    def apply_attributes_relationship(game_system)
      return unless attributes_groups

      self.calculator = ::RPG::Calculator.new

      # calculate_attributes_modifiers
      save_attributes_as_variables
      calculate_group_points(game_system)

      self
    end

    private

    def nested_attributes
      %w(pages attributes_groups)
    end

    def save_attributes_as_variables
      attributes_groups.each do |group|
        next unless group.character_attributes

        group.character_attributes.each do |attribute|
          self.calculator.add_variable(group.name, attribute.name, attribute.value)
        end
      end
    end

    # Private: iterates through the game's attributes' groups collecting those
    # with a formula to be parsed. It is important to note that it must use
    # the game system's attributes groups because only the game knows the rules
    # to be applied.
    #
    # The points will be set on the character sheet attributes group, they
    # will be different for each character in the game.
    def calculate_group_points(game_system)
      game_system.sheet.attributes_groups.each do |group|
        if group.group_points_formula.present?
          character_group = self.find_attributes_group(group.name)
          character_group.points = self.calculator.evaluate(group.group_points_formula)
        end
      end
    end
  end
end
