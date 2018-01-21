# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttributesGroupHelper, type: :helper do
  before do
    allow_any_instance_of(Sheet::AttributesGroup).to receive(:points).and_return(group_points_formula.to_i)
  end

  context 'when there are points available to spend' do
    let(:group_points_formula) { '100' }

    it 'return the class for the counter' do
      group = Sheet::AttributesGroup.new(group_points_formula: group_points_formula, character_attributes: [])
      expect(helper.class_for_points_counter(group)).to eq('available-points')
    end
  end

  context 'when there are no points available' do
    let(:group_points_formula) { '10' }

    it 'return the class for the counter' do
      group = Sheet::AttributesGroup.new(group_points_formula: group_points_formula, character_attributes: [{ points: 10 }])
      expect(helper.class_for_points_counter(group)).to be_empty
    end
  end

  context 'when the user has used more points than he/she had' do
    let(:group_points_formula) { '1' }

    it 'return the class for the counter' do
      group = Sheet::AttributesGroup.new(group_points_formula: group_points_formula, character_attributes: [{ points: 10 }])
      expect(helper.class_for_points_counter(group)).to eq('exceeded-points')
    end
  end
end
