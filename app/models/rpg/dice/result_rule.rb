module RPG
  module Dice
    class ResultRule
      include EmbeddedModel

      attribute :name, :string
      attribute :position, :integer
      attribute :color, :string
      attribute :formula, :string
      attribute :signal, :string
    end
  end
end
