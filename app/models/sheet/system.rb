# frozen_string_literal: true

module Sheet
  class System
    include EmbeddedModel
    attr_accessor :name, :initiative, :life, :sheet, :dice_roll_rules,
      :dice_result_rules, :tables, :equipments

    def find_table(table_name)
      self.tables.detect {|table| table.name == table_name }
    end

    private

    def nested_attributes
      %w(initiative life sheet dice_roll_rules dice_result_rules tables equipments)
    end
  end
end
