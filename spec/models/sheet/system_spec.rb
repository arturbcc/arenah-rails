# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sheet::System, type: :model do
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

  describe '#find_table' do
    let(:system) { Sheet::System.new(name: 'Daemon', tables: [{ name: 'carregar' }, { name: 'levantar' }]) }

    it 'finds a table by the name' do
      expect(system.find_table('carregar')).not_to be_nil
    end

    it 'returns nil with no table is found' do
      expect(system.find_table('bônus de dano')).to be_nil
    end
  end
end
