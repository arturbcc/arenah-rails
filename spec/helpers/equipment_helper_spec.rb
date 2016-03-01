require 'rails_helper'

describe EquipmentHelper do
  describe '#equipment_image' do
    let(:game) { 'crossover' }
    let(:image_name) { 'sword' }

    context 'without options' do
      it 'renders an image for the equipment' do
        image_path = helper.send('image_path', game, image_name)
        expect(helper.equipment_image(game, image_name)).to eq(image_tag(image_path))
      end
    end

    context 'with options' do
      it 'renders an image for the equipment' do
        image_path = helper.send('image_path', game, image_name)
        image = helper.equipment_image(game, image_name, class: 'new-weapon')
        expect(image).to eq(image_tag(image_path, class: 'new-weapon'))
        expect(image).to include('new-weapon')
      end
    end
  end

  describe '#slot_name' do
    it 'detects a slot for the left-hand' do
      expect(helper.slot_name('left-hand')).to eq('Mão esquerda')
    end

    it 'detects a slot for the right-hand' do
      expect(helper.slot_name('right-hand')).to eq('Mão direita')
    end

    it 'detects a slot for the head' do
      expect(helper.slot_name('head')).to eq('Cabeça')
    end

    it 'detects a slot for the shoulder' do
      expect(helper.slot_name('shoulder')).to eq('Ombro')
    end

    it 'detects a slot for the chest' do
      expect(helper.slot_name('chest')).to eq('Tronco')
    end

    it 'detects a slot for the waist' do
      expect(helper.slot_name('waist')).to eq('Cintura')
    end

    it 'detects a slot for the legs' do
      expect(helper.slot_name('legs')).to eq('Pernas')
    end

    it 'detects a slot for the neck' do
      expect(helper.slot_name('neck')).to eq('Pescoço')
    end

    it 'detects a slot for the feet' do
      expect(helper.slot_name('feet')).to eq('Pés')
    end
  end
end
