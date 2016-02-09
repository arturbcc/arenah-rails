# frozen_string_literal: true

module RPG
  class System
    include EmbeddedModel

    attribute :name, :string
    attribute :initiative, RPG::Initiative
    attribute :life, RPG::Life
    attribute :sheet, RPG::Sheet

    attribute :dice_roll_rules, :string
    attribute :dice_results_rules, :string
    attribute :tables, :string

    # attribute :dice_roll_rules, RPG::Dice::RollRule
    # attribute :dice_roll_rules, CollectionSerializer.new(RPG::Dice::RollRule)
    # serialize :dice_results_rules, ::CollectionSerializer.new(RPG::Dice::ResultsRule)
    # serialize :tables, ::CollectionSerializer.new(RPG::Table)
  end
end
