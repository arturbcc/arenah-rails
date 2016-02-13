module RPG
  class Sheet
    include EmbeddedModel

    attr_accessor :pages, :attributes_groups

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

    private

    def nested_attributes
      %w(pages attributes_groups)
    end

    # This method overrides after_initialize created on EmbeddedModel
    def after_initialize
      apply_attributes_relationships
    end

    # This method will run after the initialize and relate all attributes groups
    # Many attributes are based in others, and formulas also depends on other
    # attributes and groups to be calculated, to it must be calculated only after
    # all the sheet is loaded.
    def apply_attributes_relationships
    end
  end
end
