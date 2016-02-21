# frozen_string_literal: true

module Sheet
  class Modifier
    include EmbeddedModel

    attr_accessor :base_attribute_group, :base_attribute_name,
      :signal, :points

    def to_s
      "#{base_attribute_name} #{signal} #{points}"
    end

    def value
      if signal == '+'
        points.to_i
      elsif signal == '-'
        -1 * points.to_i
      else
        0
      end
    end
  end
end
