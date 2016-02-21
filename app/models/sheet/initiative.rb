# frozen_string_literal: true

module Sheet
  class Initiative
    include EmbeddedModel

    attr_accessor :formula, :order
  end
end
