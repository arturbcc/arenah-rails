require 'rails_helper'

describe RPG::System do
  before(:all) do
    load_system
  end

  it 'serializes the system name' do
    expect(@system.name).to eq('Daemon')
  end
end
