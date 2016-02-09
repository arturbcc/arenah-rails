module RPG
  class TableItem
    include EmbeddedModel
    # include Tokenable

    attribute :key, :string
    attribute :value, :string
    attribute :position, :integer
  end
end
