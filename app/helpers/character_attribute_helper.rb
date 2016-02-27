# frozen_string_literal: true

module CharacterAttributeHelper
  def bar_level(points, total)
    threshold = 100
    percentage = total != 0 ? (100 * points.abs / total.abs).floor : 0
    percentage > threshold ? threshold : percentage
  end

  def bar_color(percentage)
    colors = ['red', 'orange', 'green', 'darkgreen']

    colors[(percentage / 25).floor]
  end

  def image_attribute(game_slug, attribute)
    percentage = bar_level(attribute.points, attribute.total);
    images = attribute.images.sort_by(&:type)
    image_name = images[(percentage / 25).floor].name

    image_tag "/#{game_slug}/images/images_attributes/#{image_name}"
  end

  def editable_link(options = {})
    prefix = options[:prefix]
    formula = options[:formula]
    klass = options[:class]
    type = options[:type]
    text = options[:text] || ''
    value = options[:value] || 0
    master_only = options[:master_only] || false

    value = if formula.present?
      link_to text,
        'javascript:;',
        class: klass.present? ? klass : '',
        data: {
          'editable-attribute': type,
          'master-only': master_only,
          'value': value
        }
    else
      text
    end

    content_tag :span do
      concat(prefix) if prefix.present?
      concat(value)
    end
  end

  def partial_for_attribute_type(attribute, flat_version)
    case attribute.type
    when 'image'
      flat_version ? 'name_value_total' : 'image'
    when 'bar'
      flat_version ? 'name_value_total' : 'bar'
    when 'based'
      'based'
    when 'name_value'
      'name_value'
    when 'text'
      'text'
    else
      'name_value_total'
    end
  end

  def smart_description(attribute, &block)
    klass = attribute.description.present? ? 'smart-description' : ''
    link_to 'javascript:;', class: klass do
      concat(attribute.name)
      block.call if block.present?
    end
  end
end
