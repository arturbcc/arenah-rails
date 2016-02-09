module RPG
  class Sheet
    include EmbeddedModel

    # serialize :pages, ::CollectionSerializer.new(RPG::Page)
    attr_writer :pages, :attributes_groups
    # attribute :pages, :string
    # attribute :attributes_groups, :string
  end
end
