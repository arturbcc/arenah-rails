require 'rails_helper'

describe RPG::Sheet do
  before(:all) do
    load_system
  end

  describe '#attributes_groups_by' do
    it 'lists all the groups of attributes by page and position' do
      groups = @system.sheet.attributes_groups_by(page: 1, position: 'column_1')
      expect(groups.map(&:name)).to eq(['Atributos', 'Aprimoramentos', 'Status'])
    end
  end

  describe '#pages' do
    it 'serializes all pages' do
      expect(@system.sheet.pages.count).to eq(3)
    end
  end

  describe '#attributes_groups' do
    it 'serializes all attributes groups' do
      expect(@system.sheet.attributes_groups.count).to eq(10)
    end
  end

  describe '#find_attributes_group' do
    it 'finds a group by its name' do
      group = @system.sheet.attributes_groups.last
      expect(@system.sheet.find_attributes_group('Equipamentos')).to eq(group)
    end
  end
end
