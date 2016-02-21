# frozen_string_literal: true

module Sheet
  class DiceRollRule
    include EmbeddedModel

    attr_accessor :name, :attributes_tests

    private

    def nested_attributes
      %w(attributes_tests)
    end
  end
end
