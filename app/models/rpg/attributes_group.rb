module RPG
  class AttributesGroup
    include EmbeddedModel
    # include Tokenable

    attr_writer :attributes_list, :list

    attribute :name, :string
    attribute :order, :integer
    attribute :position, :integer
    attribute :page, :integer
    attribute :instructions, :string
    attribute :show_on_posts, :boolean
    attribute :order_on_posts, :boolean
    attribute :attributes_points_formula, :string
    attribute :group_points_formula, :string

    # The type indicates what kind of attributes the group will hold.
    # Each attribute type has its own behavior. The valid types are:
    #
    # TODO: list all attribute types here
    attribute :type, :string

    # All groups are fed by a source, and there are many different source types.
    # This attribute is responsible to allow the group to find the correct
    # source. The valid source types are:
    #
    # TODO: list all source types here`
    attribute :source_type, :string

    # def type_cast_from_user(value)
    #   RPG::AttributesGroup === value ? value : RPG::AttributesGroup.new(value)
    # end

  # TODO: Remove this when the json is done
  # json structure:
  # when fixed:
  #   attributes: [
  #     {
  #
  #     }
  #   ]
  # when list:
  #   attributes: [],
  #   list:[
  #     {
  #
  #     }
  #   ]
  # when open:
  #   attributes: []
  # when table:
  #   attributes: [],
  #   //tables go inside the system, not the group, to avoid duplication in memory and be reusable
  # when equipments:
  #   equipments: []

  end
end
