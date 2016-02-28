require 'rails_helper'

describe Sheet::Modifier do
  describe '#to_s' do
    it 'returns the modifier string representation' do
      modifier = Sheet::Modifier.new(base_attribute_name: 'Agilidade', signal: '+', points: 10)
      expect(modifier.to_s).to eq('Agilidade + 10')
    end
  end

  describe '#value' do
    it 'returns the a positive value when the signal is +' do
      modifier = Sheet::Modifier.new(base_attribute_name: 'Agilidade', signal: '+', points: 10)
      expect(modifier.value).to eq(10)
    end

    it 'returns the a negative value when the signal is + but the points are negative' do
      modifier = Sheet::Modifier.new(base_attribute_name: 'Agilidade', signal: '+', points: -10)
      expect(modifier.value).to eq(-10)
    end

    it 'returns the a negative value when the signal is +' do
      modifier = Sheet::Modifier.new(base_attribute_name: 'Agilidade', signal: '-', points: 10)
      expect(modifier.value).to eq(-10)
    end

    it 'returns the a positive value when the signal is - and the points are negative' do
      modifier = Sheet::Modifier.new(base_attribute_name: 'Agilidade', signal: '-', points: -10)
      expect(modifier.value).to eq(10)
    end

    it 'returns zero when the signal is not expected' do
      modifier = Sheet::Modifier.new(base_attribute_name: 'Agilidade', signal: '*')
      expect(modifier.value).to eq(0)
    end
  end
end
