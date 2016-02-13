require 'rails_helper'

describe RPG::DiceRollRule do
  before(:all) do
    @system = load_system
  end

  it 'serializes the rule named `Padrão`' do
    rule = @system.dice_roll_rules.first
    expect(rule.name).to eq('Padrão')
    expect(rule.attributes_tests.count).to eq(4)
  end

  it 'serializes the rule named `Atributos vs Perícias`' do
    rule = @system.dice_roll_rules.last
    expect(rule.name).to eq('Atributos vs Perícias')
    expect(rule.attributes_tests.count).to eq(2)
  end
end
