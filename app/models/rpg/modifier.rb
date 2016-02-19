module RPG
  class Modifier
    include EmbeddedModel

    attr_accessor :base_attribute_group, :base_attribute_name,
      :signal, :points

    def to_s
      "#{base_attribute_name} #{signal} #{points}"
    end
  end
end
