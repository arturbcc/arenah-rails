# frozen_string_literal: true

module Sheet
  class AttributesTest
    include EmbeddedModel

    attr_accessor :number_of_attributes, :formula, :dice
  end
end
