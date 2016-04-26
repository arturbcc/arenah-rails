# frozen_string_literal: true

require 'rails_helper'

describe CharacterAttributeHelper do
  describe '#bar_level' do
    it 'returns the total if the points exceed the maximum' do
      expect(helper.bar_level(150, 100)).to eq(100)
    end

    it 'returns zero if total is zero' do
      expect(helper.bar_level(150, 0)).to eq(0)
    end

    it 'calculates the percentage of the points in comparison with the total' do
      expect(helper.bar_level(25, 50)).to eq(50)
    end

    it 'ignores negative numbers' do
      expect(helper.bar_level(-15, 60)).to eq(25)
    end
  end

  describe '#bar_color' do
    it 'returns red when the percentage < 0' do
      expect(helper.bar_color(-1)).to eq('red')
    end

    it 'returns red when the percentage < 25%' do
      expect(helper.bar_color(24)).to eq('red')
      expect(helper.bar_color(0)).to eq('red')
    end

    it 'returns orange when the 25% <= percentage < 50%' do
      expect(helper.bar_color(25)).to eq('orange')
      expect(helper.bar_color(49)).to eq('orange')
    end

    it 'returns green when the 50% <= percentage < 75%' do
      expect(helper.bar_color(50)).to eq('green')
      expect(helper.bar_color(74)).to eq('green')
    end

    it 'returns green when the percentage >= 75%' do
      expect(helper.bar_color(75)).to eq('darkgreen')
      expect(helper.bar_color(100)).to eq('darkgreen')
    end
  end

  describe '#editable_link' do
    it 'renders a span' do
      expect(helper.editable_link).to include('<span')
    end

    it 'includes a class if a formula is present' do
      expect(helper.editable_link(class: 'test-class', formula: '1D100')).to include('test-class')
    end

    it 'includes does not include a class without a formula' do
      expect(helper.editable_link(class: 'test-class', formula: '1D100')).to include('test-class')
    end

    it 'includes a prefix' do
      expect(helper.editable_link(prefix: 'prefix')).to include('prefix')
    end

    it 'includes data-attributes when there is a formula' do
      expect(helper.editable_link(formula: '1D100', type: 'list')).to include('data-editable-attribute="list"')
      expect(helper.editable_link(formula: '1D100', master_only: true)).to include('data-master-only="true"')
      expect(helper.editable_link(formula: '1D100', value: 10000)).to include('data-value="10000"')
    end

    it 'does not include a formula' do
      expect(helper.editable_link(text: 'new text')).to include('new text')
    end
  end

  describe '#partial_for_attribute_type' do
    context 'quick access (posts page)' do
      it 'discovers the type of the attribute' do
        expect(helper.partial_for_attribute_type('image')).to eq('image')
        expect(helper.partial_for_attribute_type('bar')).to eq('bar')
        expect(helper.partial_for_attribute_type('based')).to eq('based')
        expect(helper.partial_for_attribute_type('name_value')).to eq('name_value')
        expect(helper.partial_for_attribute_type('text')).to eq('text')
        expect(helper.partial_for_attribute_type('other')).to eq('name_value_total')
      end
    end

    context 'plain sheet version' do
      it 'discovers the type of the attribute' do
        expect(helper.partial_for_attribute_type('image', false)).to eq('name_value_total')
        expect(helper.partial_for_attribute_type('bar', false)).to eq('name_value_total')
        expect(helper.partial_for_attribute_type('based', false)).to eq('based')
        expect(helper.partial_for_attribute_type('name_value', false)).to eq('name_value')
        expect(helper.partial_for_attribute_type('text', false)).to eq('text')
        expect(helper.partial_for_attribute_type('other', false)).to eq('name_value_total')
      end
    end
  end

  describe '#smart_description' do
    context 'description is present' do
      it 'includes the smart-description class' do
        attribute = Sheet::CharacterAttribute.new(name: 'Força', description: 'description')
        expect(helper.smart_description(attribute)).to include('smart-description')
      end
    end

    context 'description is not present' do
      it 'does not include the smart-description class' do
        attribute = Sheet::CharacterAttribute.new(name: 'Força')
        expect(helper.smart_description(attribute)).not_to include('smart-description')
      end
    end

    it 'includes the attribute name' do
      attribute = Sheet::CharacterAttribute.new(name: 'Força')
      expect(helper.smart_description(attribute)).to include('Força')
    end

    it 'includes the block given' do
      attribute = Sheet::CharacterAttribute.new(name: 'Força')
      expect { |b| helper.smart_description(attribute, &b) }.to yield_with_no_args
    end
  end

  describe '#image_attribute' do
    let(:images) do
      [
        { type: 'danger', name: 'danger.gif' },
        { type: 'low', name: 'caution_red.gif' },
        { type: 'ok', name: 'caution.gif' },
        { type: 'safe', name: 'fine.gif' },
        { type: 'safe', name: 'super_fine.gif' }
      ]

    end

    it 'renders the danger image' do
      attribute = Sheet::CharacterAttribute.new(points: 10, total: 100, images: images)
      img = helper.image_attribute('crossover', attribute)
      expect(img).to include('/crossover/images/images_attributes/danger.gif')
    end

    it 'renders the caution red image' do
      attribute = Sheet::CharacterAttribute.new(points: 21, total: 100, images: images)
      img = helper.image_attribute('crossover', attribute)
      expect(img).to include('/crossover/images/images_attributes/caution_red.gif')
    end

    it 'renders the caution image' do
      attribute = Sheet::CharacterAttribute.new(points: 45, total: 100, images: images)
      img = helper.image_attribute('crossover', attribute)
      expect(img).to include('/crossover/images/images_attributes/caution.gif')
    end

    it 'renders the fine image' do
      attribute = Sheet::CharacterAttribute.new(points: 65, total: 100, images: images)
      img = helper.image_attribute('crossover', attribute)
      expect(img).to include('/crossover/images/images_attributes/fine.gif')
    end

    it 'renders the super fine image' do
      attribute = Sheet::CharacterAttribute.new(points: 85, total: 100, images: images)
      img = helper.image_attribute('crossover', attribute)
      expect(img).to include('/crossover/images/images_attributes/super_fine.gif')
    end
  end
end
