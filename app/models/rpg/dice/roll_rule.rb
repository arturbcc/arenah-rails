module RPG
  module Dice
    class RollRule
      include EmbeddedModel

      attribute :name, :string
      attribute :formulas, Hash
    end
  end
end
