module RPG
  class Table
    include EmbeddedModel

    attr_accessor :name, :table_items, :unit

    private

    def nested_attributes
      %w(table_items)
    end
  end
end
