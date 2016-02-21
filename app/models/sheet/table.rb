# frozen_string_literal: true

module Sheet
  class Table
    include EmbeddedModel

    attr_accessor :name, :table_items, :unit

    def value(key)
      item = table_items.detect {|item| item.key == key }
      item.present? ? item.value.to_i : 0
    end

    private

    def nested_attributes
      %w(table_items)
    end
  end
end
