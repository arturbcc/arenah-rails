module RPG
  class Initiative
    include EmbeddedModel

    def type_cast_from_user(input)
      initiative = RPG::Initiative.new
      initiative.formula = input["formula"]
      initiative.order = input["order"]
      initiative
    end

    attribute :formula, :string
    # FIXME: it was named rule before, make sure it will work everywhere
    # with the new name. Order makes more sense.
    attribute :order, :string
  end
end
