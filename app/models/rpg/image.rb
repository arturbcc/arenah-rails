module RPG
  class Image
    include EmbeddedModel

    attr_accessor :name, :type
  end
end
