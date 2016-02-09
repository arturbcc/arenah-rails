module RPG
  class Table
    include EmbeddedModel

    attr_accessor :name, :table_items, :unit
  end
end
