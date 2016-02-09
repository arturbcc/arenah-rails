module RPG
  class DiceResultRule
    include EmbeddedModel

    attr_accessor :name, :order, :color, :formula, :signal
  end
end
