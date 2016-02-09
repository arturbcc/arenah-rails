require 'rails_helper'

describe RPG::System do
  it 'loads a json and organize it on the embedded model' do
    json = File.read(File.join(Rails.root, 'db/systems', 'crossover.json'))
    system = RPG::System.new(JSON.parse(json))
    debugger
    expect(system.name).to eq('Daemon')
  end
end
