# frozen_string_literal: true

# Internal: A module to manage a list of EmbeddedModel
#
# Examples
#   class TireList
#     include EmbeddedListModel
#
#     instance_type Tire
#   end
#
#   class Tire
#     include EmbeddedModel
#
#     attribute :size
#   end
#
#   class Motorcycle
#     include EmbeddedModel
#
#     attribute :tires, TireList
#   end
#
#   motorcycle = Motorcycle.new(
#     tires: [
#       { size: 18 },
#       { size: 20 }
#     ]
#   )
#   motorcycle.tires.count # => 2
#   motorcycle.tires[0].class # => Tire Object
#   motorcycle.tires[0].size # => 18
#   motorcycle.tires[1].size # => 20
module EmbeddedListModel
  extend ActiveSupport::Concern

  included do
    include EmbeddedModel
    include Enumerable

    delegate :each, :size, :shift, :blank?, :[], to: :contents

    attribute :contents, :value

    class_attribute :defined_class_name, instance_writer: false
    self.defined_class_name = nil

    def initialize(contents = [])
      self.contents = contents.map do |options|
        ActiveRecord::Type.const_get(self.defined_class_name.to_s).new(options)
      end
    end
  end

  class_methods do
    # Public: Defines the class that will be instantiated in the collection
    #
    # Examples
    #
    #   class TireList
    #     include EmbeddedListModel
    #
    #     instance_type Tire
    #   end
    #
    #   tires = TireList.new([{ size: 18 }, { size: 20 }])
    #   tires.class # => TireList
    #   tires.kind_of? Enumerable # => true
    #   tires.first.class # => Tire
    def instance_type(class_name)
      self.defined_class_name = class_name
    end
  end
end
