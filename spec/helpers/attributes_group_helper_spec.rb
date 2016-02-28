# frozen_string_literal: true

require 'rails_helper'

describe AttributesGroupHelper do
  context 'when there are points available to spend' do
    it 'return the class for the counter' do
      group = Sheet::AttributesGroup.new(points: 100, character_attributes: [])
      expect(helper.class_for_points_counter(group)).to eq('available-points')
    end
  end

  context 'when there are no points available' do
    it 'return the class for the counter' do
      group = Sheet::AttributesGroup.new(points: 10, character_attributes: [{ points: 10 }])
      expect(helper.class_for_points_counter(group)).to eq('')
    end
  end

  context 'when the user has used more points than he/she had' do
    it 'return the class for the counter' do
      group = Sheet::AttributesGroup.new(points: 1, character_attributes: [{ points: 10 }])
      expect(helper.class_for_points_counter(group)).to eq('exceeded-points')
    end
  end
end
