module RPG
  class TableItem
    include EmbeddedModel

    attr_accessor :key, :value, :order
  end
end
