module RPG
  class Initiative
    include EmbeddedModel

    attr_accessor :formula, :order
  end
end
