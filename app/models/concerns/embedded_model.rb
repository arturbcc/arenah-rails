# frozen_string_literal: true

module EmbeddedModel
  extend ActiveSupport::Concern

  included do
    def initialize(hash = {})
      hash.except(nested_attributes).each do |key, value|
        self.public_send("#{key}=", value)
      end

      save_nested_values(hash)
    end
  end

  private

  def nested_attributes
    []
  end

  def save_nested_values(hash)
    nested_attributes.each do |attribute|
      next unless hash[attribute]

      if hash[attribute].class == Array
        value = array_values(hash, attribute)
      else
        value = hash_values(hash, attribute)
      end

      self.public_send("#{attribute}=", value)
    end
  end

  def array_values(hash, attribute)
    hash[attribute].map do |attr|
      "Sheet::#{attribute.classify}".constantize.new(attr)
    end
  end

  def hash_values(hash, attribute)
    "Sheet::#{attribute.classify}".constantize.new(hash[attribute])
  end
end
