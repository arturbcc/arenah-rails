require 'rails_helper'

describe RPG::Sheet do
  before do
    json = File.read(File.join(Rails.root, 'db/systems', 'crossover.json'))
    @system = RPG::System.new(JSON.parse(json))
  end

  it 'lists all the groups of attributes by page and position' do
    groups = @system.sheet.attributes_groups_by(page: 1, position: 'column_1')
    expect(groups.map(&:name)).to eq(['Atributos', 'Aprimoramentos', 'Status'])
  end
end
