module Legacy
  class LegacyModel
    def initialize(hash = {})
      hash = ActiveSupport::HashWithIndifferentAccess.new(hash)
      hash.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end
end
