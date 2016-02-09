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

    private

    def nested_attributes
      %w(pages attributes_groups)
    end
  end
end
