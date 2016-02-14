module RPG
  class CharacterAttribute
    include EmbeddedModel

    attr_accessor :name, :order, :type, :master_only, :description,
      :formula, :action, :base_attribute_group, :base_attribute_name,
      :abbreviation, :table_name, :cost, :prefix, :content, :points,
      :total

    # Public: returns the final value of the attribute
    #
    # This method is used to be called on a formula. When an attribute is
    # used as a variable, it must provide a value to be used in the math.
    #
    # Returns: points, if points are present. Content, converted to float,
    # otherwise
    def value
      points || content.to_f
    end
  end
end
