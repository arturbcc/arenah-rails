module RPG
  class CharacterAttribute
    include EmbeddedModel

    attr_accessor :name, :order, :type, :master_only, :description,
      :formula, :action, :base_attribute_group, :base_attribute_name,
      :abbreviation, :table_name, :cost, :prefix, :content, :points,
      :total, :images

    # Attributes that are not stored in the database
    attr_accessor :equipment_modifier, :base_attribute

    # Public: returns the final value of the attribute
    #
    # This method is used to be called on a formula. When an attribute is
    # used as a variable, it must provide a value to be used in the math.
    #
    # Returns: points, if points are present. Content, converted to float,
    # otherwise
    def value
      if cost
        cost
      elsif points
        base_points = base_attribute.present? ? base_attribute.value : 0
        points + base_points
        # TODO: sum the modifiers here as well
      else
        content.to_i
      end
    end

    def to_s
      "#{points} / #{value}"
    end

    private

    def nested_attributes
      %w(images)
    end
  end
end
