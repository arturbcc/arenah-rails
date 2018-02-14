# frozen_string_literal: true

module Sheet
  class CharacterAttribute
    include EmbeddedModel

    attr_accessor :name, :order, :type, :master_only, :description,
      :formula, :action, :base_attribute_group, :base_attribute_name,
      :abbreviation, :table_name, :cost, :prefix, :content, :points,
      :total, :images

    # Attributes that are not stored in the database
    attr_accessor :equipment_modifier, :base_attribute, :unit

    # Public: returns the value of the attribute
    #
    # This method is used to be called on a formula. When an attribute is
    # used as a variable, it must provide a value to be used in the math.
    #
    # Returns a number according to these rules:
    #
    # * If the attribute has a cost, it will be the attribute value.
    # * Else, if there are points on it, the points will be summed up with
    #   the based attribute value and the modifiers
    # * At last, if no rule was matched, it returns the content.
    def value
      if cost
        cost.to_i
      elsif points
        points.to_i + base_attribute.try(:value).to_i + equipment_modifier.to_i
      elsif content
        content.to_i
      else
        points.to_i
      end
    end

    def to_s
      "#{points} / #{value}"
    end

    def to_params(options = {})
      params = {
        attribute_name: name,
        points: points,
        value: total || value,
        equipment_modifier: equipment_modifier,
        type: type
      }.merge(options)
      params[:base_attribute_group] = base_attribute_group if base_attribute_group.present?
      params[:base_attribute_name] = base_attribute_name if base_attribute_name.present?

      params
    end

    private

    def nested_attributes
      %w(images)
    end
  end
end
