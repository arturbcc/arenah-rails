# frozen_string_literal: true

# Public: Serialize a collection of objects based on a given serializer class.
# The serializer class can be any `EmbeddedModel` or any object that implements
# a `.load` and a `.dump` method.
#
# Examples
#
#   class Proposal < ActiveRecord::Base
#     serialize :coverages, CollectionSerializer.new(Coverage)
#   end
#
#   proposal = Proposal.new(
#     coverages: [{...}, {...}]
#   )
#   proposal.coverages
#   => [#<Coverage:0x007fbeccb98970 @attributes={...}>,
#       #<Coverage:0x007fbeccb98971 @attributes={...}>]
class CollectionSerializer
  def initialize(klass)
    @klass = klass
  end

  def load(collection)
    Array(collection).map { |attributes| @klass.load(attributes) }
  end

  def dump(collection)
    Array(collection).map { |object| @klass.dump(object) }
  end
end
