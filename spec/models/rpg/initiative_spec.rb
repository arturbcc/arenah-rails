require 'rails_helper'

describe RPG::Initiative do
  before(:all) do
    @system = load_system
  end

  it 'serializes the initiative formula' do
    expect(@system.initiative.formula).to eq('1D10 + atributos=>agilidade')
  end

  it 'serializes the initiative order criteria' do
    expect(@system.initiative.order).to eq('desc')
  end
end
