require 'rails_helper'

describe RPG::Life do
  before(:all) do
    load_system
  end

  it 'serializes the name of the group that holds the life attribute' do
    expect(@system.life.base_attribute_group).to eq('Dados')
  end

  it 'serializes the name of the attribute that representes the character life' do
    expect(@system.life.base_attribute_name).to eq('Vida')
  end
end
