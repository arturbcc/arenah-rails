require 'rails_helper'

describe RPG::System do
  before(:all) do
    json = File.read(File.join(Rails.root, 'db/systems', 'crossover.json'))
    @system = RPG::System.new(JSON.parse(json))
  end

  describe '#system' do
    let(:subject) { @system }

    it 'serializes the system name' do
      expect(subject.name).to eq('Daemon')
    end
  end

  describe '#initiative' do
    let(:subject) { @system.initiative }

    it 'serializes the initiative formula' do
      expect(subject.formula).to eq('1D10 + #{Atributos:Agilidade}')
    end

    it 'serializes the initiative order criteria' do
      expect(subject.order).to eq('desc')
    end
  end

  describe '#life' do
    let(:subject) { @system.life }

    it 'serializes the name of the group that holds the life attribute' do
      expect(subject.base_attribute_group).to eq('Dados')
    end

    it 'serializes the name of the attribute that representes the character life' do
      expect(subject.base_attribute_name).to eq('Vida')
    end
  end

  describe '#sheet' do
    let(:subject) { @system.sheet }

    describe '#pages' do
      it 'serializes all pages' do
        expect(subject.pages.count).to eq(3)
      end

      it 'put numbers on each page' do
        expect(subject.pages.map(&:number)).to eq([1, 2, 3])
      end

      it 'saves the numbers of columns on each page' do
        expect(subject.pages.map(&:number_of_columns)).to eq([2, 2, 1])
      end

      it 'shows header on the first page' do
        expect(subject.pages.first.show_header?).to be_truthy
      end

      it 'does not show header on the second page' do
        expect(subject.pages[1].show_header?).to be_falsy
      end

      it 'does not show header on the last page' do
        expect(subject.pages.last.show_header?).to be_falsy
      end
    end

    describe '#attributes_groups' do
      it 'serializes all attributes groups' do
        expect(subject.attributes_groups.count).to eq(10)
      end

      it 'serializes the group "Dados"' do
        group = subject.attributes_groups.first
        expect(group.name).to eq('Dados')
        expect(group.page).to eq(1)
        expect(group.order).to eq(1)
        expect(group.type).to eq('character_card')
        expect(group.position).to eq('header')
        expect(group.source_type).to eq('fixed')
        expect(group.show_on_posts?).to be_falsy
        expect(group.instructions).not_to be_empty
      end
    end
  end
end
