# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sheet::AttributesTest, type: :model do
  before(:all) do
    @system = load_system
  end

  describe 'Padrão' do
    let(:rule) { @system.dice_roll_rules.first }

    it 'serializes the test for one attribute' do
      attributes_test = rule.attributes_tests.first
      expect(attributes_test.formula).to eq('A1')
      expect(attributes_test.number_of_attributes).to eq(1)
      expect(attributes_test.dice).to eq('1D100')
    end

    it 'serializes the test for two attributes' do
      attributes_test = rule.attributes_tests[1]
      expect(attributes_test.formula).to eq('A1 - A2 + 50')
      expect(attributes_test.number_of_attributes).to eq(2)
      expect(attributes_test.dice).to eq('1D100')
    end

    it 'serializes the test for three attributes' do
      attributes_test = rule.attributes_tests[2]
      expect(attributes_test.formula).to eq('A1 + A2 - A3 + 50')
      expect(attributes_test.number_of_attributes).to eq(3)
      expect(attributes_test.dice).to eq('1D100')
    end

    it 'serializes the test for four attributes' do
      attributes_test = rule.attributes_tests.last
      expect(attributes_test.formula).to eq('A1 + A2 - A3 - A4 + 50')
      expect(attributes_test.number_of_attributes).to eq(4)
      expect(attributes_test.dice).to eq('1D100')
    end
  end

  describe 'Atributos vs Perícias' do
    let(:rule) { @system.dice_roll_rules.last }

    it 'serializes the test for one attribute' do
      attributes_test = rule.attributes_tests.first
      expect(attributes_test.formula).to eq('A1')
      expect(attributes_test.number_of_attributes).to eq(1)
      expect(attributes_test.dice).to eq('1D100')
    end

    it 'serializes the test for two attributes' do
      attributes_test = rule.attributes_tests[1]
      expect(attributes_test.formula).to eq('A1 * A2 + 10')
      expect(attributes_test.number_of_attributes).to eq(2)
      expect(attributes_test.dice).to eq('1D100')
    end
  end
end
