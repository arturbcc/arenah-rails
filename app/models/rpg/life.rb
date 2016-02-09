module RPG
  class Life
    include EmbeddedModel

    attr_accessor :base_attribute_group, :base_attribute_name
  end
end
