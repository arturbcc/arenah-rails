# frozen_string_literal: true

module Sheet
  class TableItem
    include EmbeddedModel

    attr_accessor :key, :value, :order
  end
end
