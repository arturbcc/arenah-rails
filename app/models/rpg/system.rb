# frozen_string_literal: true

module RPG
  class System
    include EmbeddedModel
    attr_accessor :name, :initiative, :life, :sheet, :dice_roll_rules,
      :dice_result_rules, :tables, :equipments

    private

    def nested_attributes
      %w(initiative life sheet dice_roll_rules dice_result_rules tables equipments)
    end
  end
end
