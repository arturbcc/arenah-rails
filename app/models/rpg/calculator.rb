require 'i18n'

module RPG
  class Calculator
    attr_reader :calculator

    def initialize
      @calculator = Dentaku::Calculator.new
    end

    def add_variable(group_name, attribute_name, value)
      return if group_name.blank? || attribute_name.blank?

      key = variable_format(group_name, attribute_name)
      self.calculator.store("#{key}" => value)
    end

    def evaluate(formula)
      self.calculator.evaluate(valid_formula(formula))
    end

    private

    def variable_format(group_name, attribute_name)
      "#{group_name.parameterize}__#{attribute_name.parameterize}"
    end

    def valid_formula(formula)
      remove_accents(formula.gsub('=>','__'))
    end

    def remove_accents(string)
      I18n.transliterate(string.downcase)
    end
  end
end
