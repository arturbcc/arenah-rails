# frozen_string_literal: true

module Sheet
  class DiceResultRule
    include EmbeddedModel

    attr_accessor :name, :order, :color, :formula, :signal
  end
end
