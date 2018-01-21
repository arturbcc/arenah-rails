# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sheet::DiceResultRule, type: :model do
  before(:all) do
    @system = load_system
  end

  it 'serializes the rule for `Critical failure`' do
    rule = @system.dice_result_rules.first
    expect(rule.name).to eq('erro crítico')
    expect(rule.order).to eq(1)
    expect(rule.color).to eq('darkred')
    expect(rule.formula).to eq('95')
    expect(rule.signal).to eq('>=')
  end

  it 'serializes the rule for `failure`' do
    rule = @system.dice_result_rules[1]
    expect(rule.name).to eq('erro')
    expect(rule.order).to eq(2)
    expect(rule.color).to eq('red')
    expect(rule.formula).to eq('chance')
    expect(rule.signal).to eq('>=')
  end

  it 'serializes the rule for `Critical success`' do
    rule = @system.dice_result_rules[2]
    expect(rule.name).to eq('acerto crítico')
    expect(rule.order).to eq(3)
    expect(rule.color).to eq('darkgreen')
    expect(rule.formula).to eq('ceil(chance / 4)')
    expect(rule.signal).to eq('<=')
  end

  it 'serializes the rule for `success`' do
    rule = @system.dice_result_rules[3]
    expect(rule.name).to eq('acerto')
    expect(rule.order).to eq(4)
    expect(rule.color).to eq('green')
    expect(rule.formula).to eq('chance')
    expect(rule.signal).to eq('<=')
  end
end
