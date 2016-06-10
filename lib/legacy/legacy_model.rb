# frozen_string_literal: true

module Legacy
  class LegacyModel
    def initialize(hash = {})
      hash = ActiveSupport::HashWithIndifferentAccess.new(hash)
      hash.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def truncate(str, length = 20)
      return str if str.length <= length

      str[0..length - 4] + '...'
    end
  end
end
