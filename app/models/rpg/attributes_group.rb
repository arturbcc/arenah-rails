module RPG
  class AttributesGroup
    include EmbeddedModel

    attr_accessor :name, :order, :position, :page, :instructions,
      :show_on_posts, :order_on_posts, :attributes_points_formula,
      :group_points_formula, :character_attributes, :list, :equipments,

      # The type indicates what kind of attributes the group will hold.
      # Each attribute type has its own behavior. The valid types are:
      #
      # TODO: list all attribute types here
      :type,

      # All groups are fed by a source, and there are many different source types.
      # This attribute is responsible to allow the group to find the correct
      # source. The valid source types are:
      #
      # TODO: list all source types here`
      :source_type

      def show_on_posts?
        !!show_on_posts
      end

      private

      def nested_attributes
        %w(character_attributes list equipments)
      end
  end
end
