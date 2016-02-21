# frozen_string_literal: true

module Sheet
  class Image
    include EmbeddedModel

    attr_accessor :name, :type
  end
end
