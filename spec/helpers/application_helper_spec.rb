# frozen_string_literal: true

require 'rails_helper'

describe ApplicationHelper do
  describe '#icon' do
    it 'renders a font-awesome icon' do
      expect(helper.icon('home')).to eq('<i class="fa fa-home"></i>')
    end
  end
end
