require 'rails_helper'

describe RPG::Sheet do
  before(:all) do
    @system = load_system
  end

  describe 'System sheet' do
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

  describe 'Character sheet' do
    before(:all) do
      @sheet = load_sheet('crossover', 'inuyasha')
      @sheet.apply_attributes_relationship
    end

    context 'apply relationships and parse formulas on attributes groups' do
      describe 'attributes groups points' do
        it 'parse formula on group `Attributos`' do
          group = @sheet.find_attributes_group('Atributos')

          # It will parse the formula "100 + dados=>nivel"
          #
          # where:
          # * dados=>nivel = 1
          expect(group.points).to eq(101)
        end

        it 'parse formula on group `Perícias`' do
          group = @sheet.find_attributes_group('Perícias')

          # It will parse the formula "10 * dados=>idade + 5 * atributos=>inteligencia"
          #
          # where:
          # * dados=>idade = 25
          # * atributos=>inteligencia = 17
          expect(group.points).to eq(335)
        end

        it 'parse formula on group `Perícias`' do
          group = @sheet.find_attributes_group('Aprimoramentos')

          # It will parse the formula "5 + floor(dados=>nivel / 3)"
          #
          # where:
          # * dados=>nivel = 1
          expect(group.points).to eq(5)
        end
      end
    end
  end
end
