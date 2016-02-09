# frozen_string_literal: true

# Internal: An enhacing module for non Active Record classes that are embedded
# on persisted models through a `JSONB` column.
#
# Including the `EmbeddedModel` module provides attribute definition support,
# with typecasting, JSON conversion and querying methods.
#
# Examples
#
#   class Person
#     include EmbeddedModel
#
#     attribute :name, :string, default: 'John Doe'
#     attribute :date_of_birth, :date
#   end
#
#   person = Person.new(date_of_birth: '09/11/2015')
#   person.date_of_birth # => Date Object
#   person.name? # => true
#   person.name # => 'John Doe'
#   person.as_json # => { "name" => "John Doe", "date_of_birth" => "2015-11-09" }
module EmbeddedModel
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Model
    include ActiveModel::AttributeMethods

    attribute_method_suffix '='
    attribute_method_suffix '?'

    class_attribute :defined_attributes, instance_writer: false
    self.defined_attributes = {}

    def type_cast_from_user(input)
      debugger
      # assign_attributes(input)
      input.each do |key, value|
        if value.class == Array
          arr = []
          debugger
          klass = RPG.const_get key.classify
          value.each do |item|
            arr << klass.new(item)
          end
          self.send("#{key}=", arr)
        else
          self.send("#{key}=", value)
        end
      end
    end
  end

  # Public: Get the `Hash` of attributes of this model.
  # Empty attributes will be present in the Hash, with their predefined
  # default value or `nil`.
  #
  # Returns a `Hash`.
  def attributes
    @attributes ||= attributes_with_defaults
  end

  # Public: Get the `Hash` of values that can be serialized as `JSON` for this
  # model.
  #
  # Returns a `Hash`.
  def as_json(options = nil)
    attributes.as_json(options)
  end

  # Public: Checks if the record was marked for destruction and wasn't removed
  # from memory.
  # This method exists for compabitlity with Rails `AssociatedValidator`
  # validator used by the parent model that embeds a model.
  #
  # TODO: Remove this when we upgrade to Rails 5.0.
  #
  # Returns false.
  def marked_for_destruction?
    false
  end

  # Public: Allows you to set all the attributes by passing in a hash of
  # attributes with keys matching the attribute names.
  #
  # TODO: Remove this when we upgrade to Rails 5.0.
  #
  # Returns nothing.
  def assign_attributes(hash)
    hash.each { |attr, value| self.public_send("#{attr}=", value) }
  end

  private

  # Internal: Read the value of an attribute, used by the generated attribute
  # reader method of each attribute.
  #
  # name - a `String` with the name of the attribute.
  #
  # Examples
  #  person = Person.new
  #  person.name # => person.attribute('name')
  #
  # Returns the value of the attribute.
  def attribute(name)
    attributes[name]
  end

  # Internal: Set the value of an attribute, used by the generated attribute
  # setter method of each attribute.
  #
  # name  - a `String` with the name of the attribute.
  # input - The value of the attribute that should be set.
  #
  # Examples
  #  person = Person.new
  #  person.name = 'Heinsenberg' # => person.attribute=('name', 'Heinsenberg')
  #
  # Returns nothing.
  def attribute=(name, input)
    value = cast_attribute_value(name, input)

    if value.nil?
      attributes[name] = defined_attributes[name][:default]
    else
      attributes[name] = value
    end
  end

  # Internal: Query the value of an attribute, used by the generated attribute
  # query method of each attribute.
  #
  # name - a `String` with the name of the attribute.
  #
  # Examples
  #  person = Person.new
  #  person.name? # => person.attribute?('name')
  #
  # Returns true of the attribute is present, otherwise false.
  def attribute?(name)
    attributes[name].present?
  end

  # Internal: Type cast an attribute value (supplied by the end user) through
  # the defined type of the given attribute.
  #
  # name  - A `String` with the name of the attribute.
  # input - The value of the attribute that should be casted.
  #
  # Returns the value of the attribute.
  def cast_attribute_value(name, input)
    type = defined_attributes[name][:type]

    # TODO: Remove this when we upgrade to Rails 5.0.
    type.type_cast_from_user(input)
  end

  # Internal: Transform the `Hash` of defined attributes into a `Hash` of names
  # and default values that can be used by this instance.
  #
  # Returns a `Hash`.
  def attributes_with_defaults
    defined_attributes.transform_values { |attribute| attribute[:default] }
  end

  class_methods do
    # Public: Defines an attribute with a type on this model. The attribute will
    # be available as an attribute accessor on the model instance similar to
    # what `attr_accessor` would provide, but with support for proper type casting
    # onto the given cast (so a `String` value from a POST request will be casted
    # to a `Date` or `Integer`) and a fallback for default values if the attribute
    # isn't set in the instance object.
    #
    # name      - A `Symbol` with the name of the attribute.
    # cast_type - A `Symbol` such as `:string` or `:integer` that identifies the
    # type to be used, or a type object that responds to `type_cast_from_user`.
    #
    # Examples
    #
    #   class Person
    #     include EmbeddedModel
    #
    #     attribute :name, :string, default: 'John Doe'
    #     attribute :date_of_birth, :date
    #   end
    #
    #   person = Person.new
    #   person.name # => 'John Doe'
    #
    #   # the `09/11/2015` String will be properly cast into a `Date` object,
    #   # as the attribute is annotated with the `:date` type.
    #   person.date_of_birth = '09/11/2015'
    #
    #   person.date_of_birth # => Mon, 09 Nov 2015
    #
    # TODO: This method is an adaptation of `ActiveRecord::Attributes::ClassMethods#attribute`,
    # and on Rails 5 it should be available on the `ActiveModel::Attributes` module,
    # with a similar API that would make this method unecessary, but given the
    # current state of the upstream implementation we can predict the exact
    # difference betweens the implementations and which parts of our implementation
    # will become obsolete once Rails provides this method for us.
    #
    # Returns nothing.
    def attribute(name, cast_type, **options)
      default = options.delete(:default)
      type = lookup(cast_type, **options)

      defined_attributes[name.to_s] = { type: type, default: default }
      define_attribute_method name
    end

    # Public: Loads attributes to an `EmbeddedModel` object.
    #
    # Examples
    #
    #   class Person
    #     include EmbeddedModel
    #
    #     attribute :name, :string, default: 'John Doe'
    #     attribute :date_of_birth, :date
    #   end
    #
    #   class Proposal < ActiveRecord::Base
    #     serialize :person, Person
    #   end
    #
    #   proposal = Proposal.new(
    #     person: { name: 'Johnny', date_of_birth: '01/01/2001' }
    #   )
    #
    #   proposal.person
    #   => #<Person:0x007fbeccb98970
    #    @attributes={"name"=>"Johnny", "date_of_birth"=>Mon, 01 Jan 2001}>
    #
    # Returns a EmbeddedModel Object.
    def load(attributes)
      new(attributes)
    end

    # Public: Dumps an object as a JSON. It'll receive a `EmbeddedModel` and
    # convert it to a `JSON` to be saved on database.
    #
    # Returns a Hash object.
    def dump(object)
      object.as_json
    end

    private

    # Internal: Lookup a type implementation based on a simplified `Symbol` name.
    #
    # type    - A `Symbol` with the simplified name of the desired type class.
    # options - A `Hash` of options for the type class constructor.
    #
    # TODO: Replace this with `ActiveRecord::Type.lookup` when we upgrade to Rails 5.0.
    #
    # Returns an instance of the type class.
    def lookup(type, **options)
      klass = type.to_s.classify
      ActiveRecord::Type.const_get(klass).new(options)
    end
  end
end
