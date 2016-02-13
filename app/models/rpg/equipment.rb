module RPG
  class Equipment
    include EmbeddedModel

    attr_accessor :name, :description, :image, :slots, :modifiers,
      :initiative, :damage, :ip

    # these attributes are only used on the character equipment list
    attr_accessor :equipped_on, :order

    private

    def nested_attributes
      %w(slots modifiers)
    end
  end
end
