module RPG
  class Table
    include EmbeddedModel
    # include Tokenable

    attribute :name, :string
    serialize :items, ::CollectionSerializer.new(RPG::TableItem)
  end
end
