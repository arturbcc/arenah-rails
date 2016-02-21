# frozen_string_literal: true

require 'rails_helper'

describe Sheet::System do
  before(:all) do
    @system = load_system
  end

  it 'serializes the system name' do
    expect(@system.name).to eq('Daemon')
  end

  describe '#dice_roll_rules' do
    it 'serializes all dice roll rules' do
      expect(@system.dice_roll_rules.count).to eq(2)
    end
  end

  describe '#dice_result_rules' do
    it 'serializes all dice result rules' do
      expect(@system.dice_result_rules.count).to eq(4)
    end
  end

  describe '#tables' do
    it 'serializes all tables' do
      expect(@system.tables.count).to eq(4)
    end
  end
end
