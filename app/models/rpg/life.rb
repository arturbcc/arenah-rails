module RPG
  class Life
    include EmbeddedModel

    # These attributes are unique keys that identify
    # the group and the source where the life is. Life is an important, special
    # attribute because we must be allowed to cause automatic damage, so we
    # need to know where the life attribute dwells.
    attribute :attributes_group_token, :string
    attribute :source_token, :string
    attribute :base_attribute_group, :string
    attribute :base_attribute_name, :string
  end
end
